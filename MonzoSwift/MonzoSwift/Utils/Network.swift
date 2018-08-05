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
    case error(code: Int, response: String)
}

public enum RequestType: String {
    case get = "GET"
    case post = "POST"
}

typealias NetworkResponse = Either<Error, Data>

class Network {
    
    /// Perform a network request
    ///
    /// - Parameters:
    ///   - requestType: Type of request (GET/POST)
    ///   - url: URL to request
    ///   - headers: Additional headers to be added to the request
    ///   - body: Request body contents
    ///   - callback: Result of the request, either valid data or an error
    static public func request(requestType: RequestType = .get,
                               url: URL,
                               headers: [String:String] = [:],
                               body: [String: String] = [:],
                               callback: @escaping(_ result: NetworkResponse) -> Void) {
        
        var request = URLRequest(url: url)
        headers.forEach({request.addValue($0.value, forHTTPHeaderField: $0.key)})
        request.httpMethod = requestType.rawValue
        request.httpBody = body.compactMap({"\($0.key)=\($0.value)"}).joined(separator: "&").data(using: .utf8)
        
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
    
            switch httpStatus.statusCode {
            case 200:
                callback(Either.result(data))
            default:
                callback(Either.error(NetworkError.error(code: httpStatus.statusCode, response: String(data: data, encoding: .utf8) ?? "Could not decode response" )))
            }
        }.resume()
    }
}

