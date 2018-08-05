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
    
    var closed: Bool
    var created: String
    var description: String
    var id: String
    var owners: [MonzoOwner]
    var type: String
    var accountNumber: String?
    var sortCode: String?
    
    init(closed: Bool, created: String, description: String, id: String, owners: [MonzoOwner], type: String, accountNumber: String?, sortCode: String?){
        self.closed = closed
        self.created = created
        self.description = description
        self.id = id
        self.owners = owners
        self.type = type
        self.accountNumber = accountNumber
        self.sortCode = sortCode
    }    
}

public struct MonzoOwner: Decodable {
    private enum CodingKeys: String, CodingKey {
        case preferredName = "preferred_name"
        case userID = "user_id"
    }
    
    var preferredName: String
    var userID: String
    
    init(preferredName: String, userID: String){
        self.preferredName = preferredName
        self.userID = userID
    }
}
