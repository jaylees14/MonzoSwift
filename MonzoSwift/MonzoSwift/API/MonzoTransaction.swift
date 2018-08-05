//
//  MonzoTransaction.swift
//  MonzoSwift
//
//  Created by Jay Lees on 19/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

// FIX THIS!
public struct MonzoTransactions: Decodable {
    var transactions: [MonzoTransaction]
}

public struct MonzoTransaction: Decodable {
    private enum CodingKeys: String, CodingKey {
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
    
    let accountBalance: Int
    let amount: Int
    let created: String
    let currency: Currency
    let description: String
    let id: String
    let merchant: String?
    let metadata: [String: String]
    let notes: String
    let isLoad: Bool
    let settled: String
    let category: String
    
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
}
