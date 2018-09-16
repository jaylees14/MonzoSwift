//
//  NetworkError.swift
//  MonzoSwift
//
//  Created by Jay Lees on 07/08/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case invalidResponse
    case error(code: Int, response: String)
}

extension NetworkError: LocalizedError {
    public var description: String {
        switch self {
        case .invalidResponse: return "Invalid network response"
        case .error(let code, let response): return "Error \(code): \(response)"
        }
    }
}
