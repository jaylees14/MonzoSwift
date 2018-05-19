//
//  MonzoAccount.swift
//  MonzoSwift
//
//  Created by Jay Lees on 17/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

struct MonzoUser: Decodable {
    var accounts: [MonzoAccount]
}

struct MonzoAccount: Decodable {
    private enum AccountKeys: String, CodingKey {
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AccountKeys.self)
        
        let closed = try container.decode(Bool.self, forKey: .closed)
        let created = try container.decode(String.self, forKey: .created)
        let description = try container.decode(String.self, forKey: .description)
        let id = try container.decode(String.self, forKey: .id)
        let owners = try container.decode(Array<MonzoOwner>.self, forKey: .owners)
        let type = try container.decode(String.self, forKey: .type)
        let accountNumber = try container.decodeIfPresent(String.self, forKey: .accountNumber)
        let sortCode = try container.decodeIfPresent(String.self, forKey: .sortCode)
        
        self.init(closed: closed, created: created, description: description, id: id, owners: owners, type: type, accountNumber: accountNumber, sortCode: sortCode)
    }
    
}

struct MonzoOwner: Decodable {
    private enum OwnerKeys: String, CodingKey {
        case preferredName = "preferred_name"
        case userID = "user_id"
    }
    
    var preferredName: String
    var userID: String
    
    init(preferredName: String, userID: String){
        self.preferredName = preferredName
        self.userID = userID
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: OwnerKeys.self)
        
        let preferredName = try container.decode(String.self, forKey: .preferredName)
        let userID = try container.decode(String.self, forKey: .userID)
        self.init(preferredName: preferredName, userID: userID)
    }
}
