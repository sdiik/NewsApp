#if WEB_AUTH_PLATFORM
import Foundation
import Combine

final class Auth0WebAuth: WebAuth {

    let clientId: String
    let url: URL
    let session: URLSession
    let storage: TransactionStore

    var telemetry: Telemetry
    var barrier: Barrier
    var logger: Logger?

    #if os(macOS)
    private let platform = "macos"
    #elseif os(iOS)
    private let platform = "ios"
    #else
    private let platform = "visionos"
    #endif
    private let responseType = "code"

    private(set) var parameters: [String: String] = [:]
    private(set) var headers: [String: String] = [:]
    private(set) var https = false
    private(set) var ephemeralSession = false
    private(set) var issuer: String
    private(set) var leeway: Int = 60 * 1000 // Default leeway is 60 seconds
    private(set) var nonce: String?
    private(set) var maxAge: Int?
    private(set) var organization: String?
    private(set) var invitationURL: URL?
    private(set) var overrideAuthorizeURL: URL?
    private(set) var provider: WebAuthProvider?
    private(set) var onCloseCallback: (() -> Void)?

    var state: String {
        return self.parameters["state"] ?? self.generateDefaultState()
    }

    lazy var redirectURL: URL? = {
        guard let bundleID = Bundle.main.bundleIdentifier, let domain = self.url.host else { return nil }
        let scheme: String

        #if compiler(>=5.10)
        if #available(iOS 17.4, macOS 14.4, *) {
            scheme = https ? "https" : bundleID
        } else {
            scheme = bundleID
        }
        #else
        scheme = bundleID
        #endif

        guard let baseURL = URL(string: "\(scheme)://\(domain)") else { return nil }
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

        return components?.url?
            .appendingPathComponent(self.url.path)
            .appendingPathComponent(self.platform)
            .appendingPathComponent(bundleID)
            .appendingPathComponent("callback")
    }()

    init(clientId: String,
         url: URL,
         session: URLSession = URLSession.shared,
         storage: TransactionStore = TransactionStore.shared,
         telemetry: Telemetry = Telemetry(),
         barrier: Barrier = QueueBarrier.shared) {
        self.clientId = clientId
        self.url = url
        self.session = session
        self.storage = storage
        self.telemetry = telemetry
        self.barrier = barrier
        self.issuer = url.absoluteString
    }

    func connection(_ connection: String) -> Self {
        self.parameters["connection"] = connection
        return self
    }

    func scope(_ scope: String) -> Self {
        self.parameters["scope"] = scope
        return self
    }

    func connectionScope(_ connectionScope: String) -> Self {
        self.parameters["connection_scope"] = connectionScope
        return self
    }

    func state(_ state: String) -> Self {
        self.parameters["state"] = state
        return self
    }

    func parameters(_ parameters: [String: String]) -> Self {
        parameters.forEach { self.parameters[$0] = $1 }
        return self
    }

    #if compiler(>=5.10)
    @available(iOS 17.4, macOS 14.4, visionOS 1.2, *)
    func headers(_ headers: [String: String]) -> Self {
        headers.forEach { self.headers[$0] = $1 }
        return self
    }
    #endif

    func redirectURL(_ redirectURL: URL) -> Self {
        self.redirectURL = redirectURL
        return self
    }

    func authorizeURL(_ authorizeURL: URL) -> Self {
        self.overrideAuthorizeURL = authorizeURL
        return self
    }

    func nonce(_ nonce: String) -> Self {
        self.nonce = nonce
        return self
    }

    func audience(_ audience: String) -> Self {
        self.parameters["audience"] = audience
        return self
    }

    func issuer(_ issuer: String) -> Self {
        self.issuer = issuer
        return self
    }

    func leeway(_ leeway: Int) -> Self {
        self.leeway = leeway
        return self
    }

    func maxAge(_ maxAge: Int) -> Self {
        self.maxAge = maxAge
        return self
    }

    func useHTTPS() -> Self {
        self.https = true
        return self
    }

    func useEphemeralSession() -> Self {
        self.ephemeralSession = true
        return self
    }

    func invitationURL(_ invitationURL: URL) -> Self {
        self.invitationURL = invitationURL
        return self
    }

    func organization(_ organization: String) -> Self {
        self.organization = organization
        return self
    }

    func provider(_ provider: @escaping WebAuthProvider) -> Self {
        self.provider = provider
        return self
    }

    func onClose(_ callback: (() -> Void)?) -> Self {
        self.onCloseCallback = callback
        return self
    }

    func start(_ callback: @escaping (WebAuthResult<Credentials>) -> Void) {
        guard barrier.raise() else {
            return callback(.failure(WebAuthError(code: .transactionActiveAlready)))
        }

        guard let redirectURL = self.redirectURL else {
            return callback(.failure(WebAuthError(code: .noBundleIdentifier)))
        }

        let handler = self.handler(redirectURL)
        let state = self.state
        var organization: String? = self.organization
        var invitation: String?

        if let invitationURL = self.invitationURL {
            guard let queryItems = URLComponents(url: invitationURL, resolvingAgainstBaseURL: false)?.queryItems,
                  let organizationId = queryItems.first(where: { $0.name == "organization" })?.value,
                  let invitationId = queryItems.first(where: { $0.name == "invitation" })?.value else {
                return callback(.failure(WebAuthError(code: .invalidInvitationURL(invitationURL.absoluteString))))
            }

            organization = organizationId
            invitation = invitationId
        }

        let authorizeURL = self.buildAuthorizeURL(withRedirectURL: redirectURL,
                                                  defaults: handler.defaults,
                                                  state: state,
                                                  organization: organization,
                                                  invitation: invitation)

        let provider = self.provider ?? WebAuthentication.asProvider(redirectURL: redirectURL,
                                                                     ephemeralSession: ephemeralSession,
                                                                     headers: headers)
        let userAgent = provider(authorizeURL) { [storage, barrier, onCloseCallback] result in
            storage.clear()
            barrier.lower()

            switch result {
            case .success:
                onCloseCallback?()
            case .failure(let error):
                callback(.failure(error))
            }
        }
        let transaction = LoginTransaction(redirectURL: redirectURL,
                                           state: state,
                                           userAgent: userAgent,
                                           handler: handler,
                                           logger: self.logger,
                                           callback: callback)
        self.storage.store(transaction)
        userAgent.start()
        logger?.trace(url: authorizeURL, source: String(describing: userAgent.self))
    }

    func clearSession(federated: Bool, callback: @escaping (WebAuthResult<Void>) -> Void) {
        guard barrier.raise() else {
            return callback(.failure(WebAuthError(code: .transactionActiveAlready)))
        }

        let endpoint = federated ?
            URL(string: "v2/logout?federated", relativeTo: self.url)! :
            URL(string: "v2/logout", relativeTo: self.url)!
        let returnTo = URLQueryItem(name: "returnTo", value: self.redirectURL?.absoluteString)
        let clientId = URLQueryItem(name: "client_id", value: self.clientId)
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)
        let queryItems = components?.queryItems ?? []
        components?.queryItems = queryItems + [returnTo, clientId]

        guard let logoutURL = components?.url, let redirectURL = self.redirectURL else {
            return callback(.failure(WebAuthError(code: .noBundleIdentifier)))
        }

        let provider = self.provider ?? WebAuthentication.asProvider(redirectURL: redirectURL, headers: headers)
        let userAgent = provider(logoutURL) { [storage, barrier] result in
            storage.clear()
            barrier.lower()
            callback(result)
        }
        let transaction = ClearSessionTransaction(userAgent: userAgent)
        self.storage.store(transaction)
        userAgent.start()
    }

    func buildAuthorizeURL(withRedirectURL redirectURL: URL,
                           defaults: [String: String],
                           state: String?,
                           organization: String?,
                           invitation: String?) -> URL {
        let authorize = self.overrideAuthorizeURL ?? URL(string: "authorize", relativeTo: self.url)!
        var components = URLComponents(url: authorize, resolvingAgainstBaseURL: true)!
        var items: [URLQueryItem] = []
        var entries = defaults

        entries["scope"] = defaultScope
        entries["client_id"] = self.clientId
        entries["response_type"] = self.responseType
        entries["redirect_uri"] = redirectURL.absoluteString
        entries["state"] = state
        entries["nonce"] = self.nonce
        entries["organization"] = organization
        entries["invitation"] = invitation

        if let maxAge = self.maxAge {
            entries["max_age"] = String(maxAge)
        }

        self.parameters.forEach { entries[$0] = $1 }

        entries["scope"] = includeRequiredScope(in: entries["scope"])
        entries.forEach { items.append(URLQueryItem(name: $0, value: $1)) }
        components.queryItems = self.telemetry.queryItemsWithTelemetry(queryItems: items)
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return components.url!
    }

    func generateDefaultState() -> String {
        let data = Data(count: 32)
        var tempData = data

        let result = tempData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, data.count, $0.baseAddress!)
        }

        guard result == 0, let state = tempData.a0_encodeBase64URLSafe()
        else { return UUID().uuidString.replacingOccurrences(of: "-", with: "") }

        return state
    }

    private func handler(_ redirectURL: URL) -> OAuth2Grant {
        var authentication = Auth0Authentication(clientId: self.clientId,
                                                 url: self.url,
                                                 session: self.session,
                                                 telemetry: self.telemetry)
        authentication.logger = self.logger
        return PKCE(authentication: authentication,
                    redirectURL: redirectURL,
                    issuer: self.issuer,
                    leeway: self.leeway,
                    maxAge: self.maxAge,
                    nonce: self.nonce,
                    organization: self.organization)
    }

}

// MARK: - Combine

extension Auth0WebAuth {

    public func start() -> AnyPublisher<Credentials, WebAuthError> {
        return Deferred { Future(self.start) }.eraseToAnyPublisher()
    }

    public func clearSession(federated: Bool) -> AnyPublisher<Void, WebAuthError> {
        return Deferred {
            Future { callback in
                self.clearSession(federated: federated) { result in
                    callback(result)
                }
            }
        }.eraseToAnyPublisher()
    }

}

// MARK: - Async/Await

#if canImport(_Concurrency)
extension Auth0WebAuth {

    func start() async throws -> Credentials {
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                self.start { result in
                    continuation.resume(with: result)
                }
            }
        }
    }

    func clearSession(federated: Bool) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            Task { @MainActor in
                self.clearSession(federated: federated) { result in
                    continuation.resume(with: result)
                }
            }
        }
    }

}
#endif
#endif
