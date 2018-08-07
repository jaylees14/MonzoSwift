//
//  MonzoAuthentication.swift
//  MonzoSwift
//
//  Created by Jay Lees on 23/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

internal struct MonzoAuthentication: Decodable {
    private enum CodingKeys: String, CodingKey {
        case authenticated = "authenticated"
        case clientID = "client_id"
        case userID = "user_id"
    }
    
    let authenticated: Bool
    let clientID: String?
    let userID: String?
}
