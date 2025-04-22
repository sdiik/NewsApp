//
//  Auth0Config.swift
//  NewsApp
//
//  Created by ahmad shiddiq on 22/04/25.
//

import Foundation

class Auth0Config {
    static let shared = Auth0Config()
    
    let clientID: String
    let domain: String
    
    private init() {
        guard
            let infoDict = Bundle.main.infoDictionary,
            let clientID = infoDict["Auth0ClientID"] as? String,
            let domain = infoDict["Auth0Domain"] as? String
        else {
            fatalError("Auth0ClientID and Auth0Domain must be set in Info.plist")
        }
        
        self.clientID = clientID
        self.domain = domain
    }
}
