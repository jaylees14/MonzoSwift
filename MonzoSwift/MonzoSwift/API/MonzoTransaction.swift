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

public struct MonzoTransactionWrapper: Decodable {
    var transaction: MonzoTransaction
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
}
