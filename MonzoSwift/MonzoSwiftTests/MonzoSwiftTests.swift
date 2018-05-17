//
//  MonzoSwiftTests.swift
//  MonzoSwiftTests
//
//  Created by Jay Lees on 17/05/2018.
//  Copyright © 2018 jaylees. All rights reserved.
//

import XCTest
@testable import MonzoSwift

class MonzoSwiftTests: XCTestCase {
    private let testToken = "REMOVED"

    func testGetAccounts(){
        let outcome = expectation(description: "Monzo returns a list of accounts associated with the token")

        let monzo = Monzo.instance
        monzo.setAccessToken(testToken)
        monzo.setAccessToken(testToken)
        monzo.getAllAccounts { (result) in
            switch result {
            case .error(let error):
                XCTFail(error.localizedDescription)
            case .result(let accounts):
                //TODO: Validate response
                XCTAssert(accounts.accounts.count >= 0)
            }
            outcome.fulfill()
        }
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("Expectation error: \(error)")
            }
        }
        
    }
    
}
