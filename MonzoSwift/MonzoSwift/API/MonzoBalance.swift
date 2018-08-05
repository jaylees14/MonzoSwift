//
//  MonzoBalance.swift
//  MonzoSwift
//
//  Created by Jay Lees on 17/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

public enum Currency: String, Decodable {
    case gbp = "GBP"
    case none = ""
    //...
}


public struct MonzoBalance: Decodable {
    private enum CodingKeys: String, CodingKey {
        case balance = "balance"
        case totalBalance = "total_balance"
        case currency = "currency"
        case spendToday = "spend_today"
        case localCurrency = "local_currency"
        case localExchangeRate = "local_exchange_rate"
    }
    
    let balance: Int
    let totalBalance: Int
    let currency: Currency
    let spendToday: Int
    let localCurrency: Currency
    let localExchangeRate: Int
    
    init(balance: Int, totalBalance: Int, currency: Currency, spendToday: Int, localCurrency: Currency, localExchangeRate: Int){
        self.balance = balance
        self.totalBalance = totalBalance
        self.currency = currency
        self.spendToday = spendToday
        self.localCurrency = localCurrency
        self.localExchangeRate = localExchangeRate
    }
}
