//
//  MonzoAuthentication.swift
//  MonzoSwift
//
//  Created by Jay Lees on 23/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

internal struct MonzoAuthentication: Decodable {
    private enum AuthenticationKeys: String, CodingKey {
        case authenticated = "authenticated"
        case clientID = "client_id"
        case userID = "user_id"
    }
    
    var authenticated: Bool
    var clientID: String?
    var userID: String?
    
    
    init(authenticated: Bool, clientID: String?, userID: String?){
        self.authenticated = authenticated
        self.clientID = clientID
        self.userID = userID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AuthenticationKeys.self)
        let authenticated = try container.decode(Bool.self, forKey: .authenticated)
        let clientID = try container.decodeIfPresent(String.self, forKey: .clientID)
        let userID = try container.decodeIfPresent(String.self, forKey: .userID)
        self.init(authenticated: authenticated, clientID: clientID, userID: userID)
    }
}
