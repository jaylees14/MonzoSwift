//
//  MonzoAccount.swift
//  MonzoSwift
//
//  Created by Jay Lees on 17/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

public struct MonzoUser: Decodable {
    var accounts: [MonzoAccount]
}

public struct MonzoAccount: Decodable {
    private enum CodingKeys: String, CodingKey {
        case closed = "closed"
        case created = "created"
        case description = "description"
        case id = "id"
        case owners = "owners"
        case type = "type"
        case accountNumber = "account_number"
        case sortCode = "sort_code"
    }
    
    let closed: Bool
    let created: String
    let description: String
    let id: String
    let owners: [MonzoOwner]
    let type: String
    let accountNumber: String?
    let sortCode: String?
}

public struct MonzoOwner: Decodable {
    private enum CodingKeys: String, CodingKey {
        case preferredName = "preferred_name"
        case userID = "user_id"
    }
    
    let preferredName: String
    let userID: String
}
