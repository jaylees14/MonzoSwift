//
//  MonzoError.swift
//  MonzoSwift
//
//  Created by Jay Lees on 17/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

public enum MonzoError: Error {
    case noAccessToken
    case decodingError
}


extension MonzoError: LocalizedError {
    public var errorDescription: String?{
        switch self {
        case .noAccessToken: return "No access token available"
        case .decodingError: return "Error whilst decoding response"
        }
    }
}
