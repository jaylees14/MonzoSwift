//
//  MonzoTransaction.swift
//  MonzoSwift
//
//  Created by Jay Lees on 19/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

// FIX THIS!
struct MonzoTransactions: Decodable {
    var transactions: [MonzoTransaction]
}

struct MonzoTransaction: Decodable {
    private enum TransactionKeys: String, CodingKey {
        case accountBalance = "account_balance"
        case amount = "amount"
        case created = "created"
        case currency = "currency"
        case description = "description"
        case id = "id"
        case merchant = "merchant"
        case metadata = "metadata"
        case notes = "notes"
        case isLoad = "is_load"
        case settled = "settled"
        case category = "category"
    }
    
    var accountBalance: Int
    var amount: Int
    var created: String
    var currency: Currency
    var description: String
    var id: String
    var merchant: String?
    var metadata: [String: String]
    var notes: String
    var isLoad: Bool
    var settled: String
    var category: String
    
    init(accountBalance: Int, amount: Int, created: String, currency: Currency, description: String, id: String, merchant: String?, metadata: [String:String], notes: String, isLoad: Bool, settled: String, category: String){
        self.accountBalance = accountBalance
        self.amount = amount
        self.created = created
        self.currency = currency
        self.description = description
        self.id = id
        self.merchant = merchant
        self.metadata = metadata
        self.notes = notes
        self.isLoad = isLoad
        self.settled = settled
        self.category = category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TransactionKeys.self)
        
        let accountBalance = try container.decode(Int.self, forKey: .accountBalance)
        let amount = try container.decode(Int.self, forKey: .amount)
        let created = try container.decode(String.self, forKey: .created)
        let currency = try container.decode(Currency.self, forKey: .currency)
        let description = try container.decode(String.self, forKey: .description)
        let id = try container.decode(String.self, forKey: .id)
        let merchant = try container.decodeIfPresent(String.self, forKey: .merchant)
        let metadata = try container.decode([String: String].self, forKey: .metadata)
        let notes = try container.decode(String.self, forKey: .notes)
        let isLoad = try container.decode(Bool.self, forKey: .isLoad)
        let settled = try container.decode(String.self, forKey: .settled)
        let category = try container.decode(String.self, forKey: .category)
        self.init(accountBalance: accountBalance, amount: amount, created: created, currency: currency, description: description, id: id, merchant: merchant, metadata: metadata, notes: notes, isLoad: isLoad, settled: settled, category: category)
    }
}
