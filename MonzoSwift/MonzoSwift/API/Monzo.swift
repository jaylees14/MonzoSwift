//
//  Monzo.swift
//  MonzoSwift
//
//  Created by Jay Lees on 17/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

class Monzo {
    private let apiBase  = "https://api.monzo.com"
    private let authBase = "https://auth.monzo.com"
    private let clientID = "oauth2client_00009WhuBh9b97lcQhyFg9"
    private let redirectUri = ""
    private var accessToken: String?
    
    public static let instance = Monzo()
    private init() {}

    public func setAccessToken(_ token: String){
        self.accessToken = token
    }
    
    public func getAllAccounts(callback: @escaping (_ accounts: Either<Error, MonzoUser>) -> Void){
        guard let token = accessToken else {
            callback(Either.error(MonzoError.noAccessToken))
            return
        }
        
        let url = apiBase + "/accounts"
        Network.getRequest(url: URL(string: url)!, headers: ["Authorization": "Bearer \(token)"]) { (response) in
            switch response {
            case .result(let result):
                self.parseJSON(to: MonzoUser.self, from: result, then: callback)
            case .error(let error):
                callback(Either.error(error))
            }
        }
    }
    
    
    public func getBalance(for account: MonzoAccount, callback: @escaping (_ balance: Either<Error, MonzoBalance>) -> Void){
        guard let token = accessToken else {
            callback(Either.error(MonzoError.noAccessToken))
            return
        }
        
        let url = apiBase + "/balance?account_id=\(account.id)"
        Network.getRequest(url: URL(string: url)!, headers: ["Authorization": "Bearer \(token)"]) { (response) in
            switch response {
            case .result(let result):
                self.parseJSON(to: MonzoBalance.self, from: result, then: callback)
            case .error(let error):
                callback(Either.error(error))
            }
        }
    }
    
    
    private func parseJSON<T: Decodable>(to: T.Type, from data: Data, then callback: @escaping (_ result: Either<Error, T>) -> Void){
        do {
            let json = try JSONDecoder().decode(T.self, from: data)
            callback(Either.result(json))
        } catch let decoderError as DecodingError {
            callback(Either.error(decoderError))
        } catch let fallbackError {
            callback(Either.error(fallbackError))
        }
    }
    
}
