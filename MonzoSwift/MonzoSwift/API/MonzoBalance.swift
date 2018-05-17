//
//  MonzoBalance.swift
//  MonzoSwift
//
//  Created by Jay Lees on 17/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

enum Currency: String, Decodable {
    case gbp = "GBP"
    case none = ""
    //...
}


struct MonzoBalance {
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

extension MonzoBalance: Decodable {
    enum BalanceKeys: String, CodingKey {
        case balance = "balance"
        case totalBalance = "total_balance"
        case currency = "currency"
        case spendToday = "spend_today"
        case localCurrency = "local_currency"
        case localExchangeRate = "local_exchange_rate"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: BalanceKeys.self)
        
        let balance = try container.decode(Int.self, forKey: .balance)
        let totalBalance = try container.decode(Int.self, forKey: .totalBalance)
        let currency = try container.decode(Currency.self, forKey: .currency)
        let spendToday = try container.decode(Int.self, forKey: .spendToday)
        let localCurrency = try container.decode(Currency.self, forKey: .localCurrency)
        let localExchangeRate = try container.decode(Int.self, forKey: .localExchangeRate)
    
        self.init(balance: balance, totalBalance: totalBalance, currency: currency, spendToday: spendToday, localCurrency: localCurrency, localExchangeRate: localExchangeRate)
    }
}
