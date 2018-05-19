//
//  Network.swift
//  MonzoSwift
//
//  Created by Jay Lees on 17/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case invalidResponse
    case unhandledResponse
}

typealias NetworkResponse = Either<Error, Data>

class Network {
    
    /// Perform a GET request
    ///
    /// - Parameters:
    ///   - url: URL to request
    ///   - headers: Additional headers to be added to the request
    ///   - callback: Result of the request, either valid data or an error
    static public func getRequest(url: URL,
                                  headers: [String:String] = [:],
                                  callback: @escaping(_ result: NetworkResponse) -> Void) {
        var request = URLRequest(url: url)
        
        //FIXME: Make this a class? With this property available as a param not incorrectly formatted dict
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                callback(Either.error(error!))
                return
            }
            
            guard let httpStatus = response as? HTTPURLResponse else {
                callback(Either.error(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                callback(Either.error(NetworkError.invalidResponse))
                return
            }
    
            //TODO: Handle more responses (eg: Network token)
            switch httpStatus.statusCode {
                case 200:
                    callback(Either.result(data))
                default:
                    callback(Either.error(NetworkError.unhandledResponse))
            }
        }.resume()
    }
}

