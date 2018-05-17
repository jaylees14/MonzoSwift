//
//  Either.swift
//  MonzoSwift
//
//  Created by Jay Lees on 17/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import Foundation

public enum Either<a,b> {
    case error(a)
    case result(b)
}

public extension Either {
    //If the value is Left a, apply the first function to a; if it is Right b, apply the second function to b.
    func either<c>(_ l: (a) -> c, _ r: (b) -> c) -> c {
        switch self {
        case let .error(x):
            return l(x)
        case let .result(y):
            return r(y)
        }
    }
    
}
