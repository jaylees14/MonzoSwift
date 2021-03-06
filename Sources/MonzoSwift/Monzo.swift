//
//  Monzo.swift
//  MonzoSwift
//
//  Created by Jay Lees on 17/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation
import SafariServices

public class Monzo {
    private let apiBase  = "https://api.monzo.com"
    private let authBase = "https://auth.monzo.com"
    private var defaultHeaders: [String: String]
    private var accessToken: String?
    
    /// The shared Monzo API instance
    public static let instance = Monzo()
    private init() {
        defaultHeaders = [:]
    }

    // MARK: - Access Tokens
    /// Set the access token for future requests
    ///
    /// - Parameter token: The access token obtained from Monzo
    public func setAccessToken(_ token: String){
        self.accessToken = token
        self.defaultHeaders = ["Authorization": "Bearer \(token)"]
    }
    
    /// Validate your existing access token
    ///
    /// - Parameter callback: Response from Monzo, either an error or boolean indicating whether it is valid or not.
    public func validateAccessToken(callback: @escaping (_ result: Either<Error, Bool>) -> Void ){
        let url = apiBase + "/ping/whoami"
        Network.request(url: URL(string: url)!, headers: defaultHeaders) { (response) in
            switch response {
            case .result(let result):
                self.parseJSON(to: MonzoAuthentication.self, from: result, then: self.determineAuthStatus(then: callback))
            
            // Monzo returns a 401 error if the token isn't authenticated
            case .error(let error as NetworkError):
                switch error {
                case .error(code: let code, response: _):
                    callback(code == 401 ? Either.result(false) : Either.error(error))
                default:
                    callback(Either.error(error))
                }
            
            // Failing the NetworkError check, default to a standard error
            case .error(let error):
                callback(Either.error(error))
            }
        }
    }
    
    // Internal method for unwrapping a MonzoAuthentication class into a Boolean
    fileprivate func determineAuthStatus(then callback: @escaping (_ result: Either<Error, Bool>) -> Void ) -> (Either<Error, MonzoAuthentication>) -> Void {
        return { response in
            response.handle({ error in
                callback(Either.error(error))
            }, { auth in
                callback(Either.result(auth.authenticated))
            })
        }
    }
    
    //MARK: - Accounts
    /// Get all accounts associated with the set access token
    ///
    /// - Parameter callback: Response from Monzo, either an error or a MonzoUser with an array of accounts
    public func getAllAccounts(callback: @escaping (_ accounts: Either<Error, [MonzoAccount]>) -> Void){
        guard accessToken != nil else {
            callback(Either.error(MonzoError.noAccessToken))
            return
        }
        
        let url = apiBase + "/accounts"
        Network.request(url: URL(string: url)!, headers: defaultHeaders) { (response) in
            switch response {
            case .result(let result):
                guard let accounts = self.extractField("accounts", from: result) else {
                    callback(Either.error(MonzoError.decodingError))
                    return
                }
                self.parseJSON(to: Array<MonzoAccount>.self, from: accounts, then: callback)
            case .error(let error):
                callback(Either.error(error))
            }
        }
    }
    
    // MARK: - Balance
    /// Retrieve the current balance for the associated Monzo account
    ///
    /// - Parameters:
    ///   - account: The account to check balance for
    ///   - callback: Response from Monzo, either an error or a MonzoBalance
    public func getBalance(for account: MonzoAccount, callback: @escaping (_ balance: Either<Error, MonzoBalance>) -> Void){
        guard accessToken != nil else {
            callback(Either.error(MonzoError.noAccessToken))
            return
        }
        
        let url = apiBase + "/balance?account_id=\(account.id)"
        Network.request(url: URL(string: url)!, headers: defaultHeaders) { (response) in
            switch response {
            case .result(let result):
                self.parseJSON(to: MonzoBalance.self, from: result, then: callback)
            case .error(let error):
                callback(Either.error(error))
            }
        }
    }
    
    // MARK: - Transactions
    /// Get all transactions associated with a Monzo Account
    ///
    /// - Parameters:
    ///   - account: The account to fetch transactions for
    ///   - callback: Response from monzo, either an error or list of MonzoTransaction
    public func getTransactions(for account: MonzoAccount, callback: @escaping (_ transactions: Either<Error, [MonzoTransaction]>) -> Void){
        guard accessToken != nil else {
            callback(Either.error(MonzoError.noAccessToken))
            return
        }
        
        let url = apiBase + "/transactions?account_id=\(account.id)"
        Network.request(url: URL(string: url)!, headers: defaultHeaders) { (response) in
            switch response {
            case .result(let result):
                guard let transactions = self.extractField("transactions", from: result) else {
                    callback(Either.error(MonzoError.decodingError))
                    return
                }
                self.parseJSON(to: Array<MonzoTransaction>.self, from: transactions, then: callback)
            case .error(let error):
                callback(Either.error(error))
            }
        }
    }
    
    /// Get a specific transaction associated with a Monzo Account
    ///
    /// - Parameters:
    ///   - id: Transaction ID
    ///   - callback: Response from Monzo, either an error or a Monzo Transaction
    public func getTransaction(for id: String, callback: @escaping ((Either<Error, MonzoTransaction>) -> Void)){
        guard accessToken != nil else {
            callback(Either.error(MonzoError.noAccessToken))
            return
        }
        
        let url = apiBase + "/transactions/\(id)"
        Network.request(url: URL(string: url)!, headers: defaultHeaders) { (response) in
            switch response {
            case .result(let result):
                guard let transaction = self.extractField("transaction", from: result) else {
                    callback(Either.error(MonzoError.decodingError))
                    return
                }
                self.parseJSON(to: MonzoTransaction.self, from: transaction, then: callback)
            case .error(let error):
                callback(Either.error(error))
            }
        }
    }
    
    
    // MARK: - Utilities
    // Parse a JSON response to a decodable type, and callback as necessary
    private func parseJSON<T: Decodable>(to: T.Type, from data: Data, then callback: @escaping (_ result: Either<Error, T>) -> Void){
        do {
            let json = try JSONDecoder().decode(T.self, from: data)
            callback(Either.result(json))
        } catch let error {
            callback(Either.error(error))
        }
    }
    
    // This returns the object for a given field in the JSON.
    private func extractField(_ field: String, from data: Data) -> Data? {
        if let json = try? JSONSerialization.jsonObject(with: data),
           let dict = json as? [String : Any],
           let requestedObject = dict[field] {
            return try? JSONSerialization.data(withJSONObject: requestedObject)
        }
        return nil
    }
    
}
