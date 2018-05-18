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
    private let timeout = 5.0

    func testGetAccounts(){
        let outcome = expectation(description: "Monzo returns a list of accounts associated with the token")

        let monzo = Monzo.instance
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
        
        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Expectation error: \(error)")
            }
        }
    }
    
    func testGetBalance(){
        let outcome = expectation(description: "Monzo returns a list of accounts associated with the token")
        
        let monzo = Monzo.instance
        monzo.setAccessToken(testToken)
        //FIXME: Extract this to a "MockAccount" class
        monzo.getAllAccounts { (accountResponse) in
            switch accountResponse {
            case .error(let error):
                    XCTFail(error.localizedDescription)
            case .result(let result):
                guard let account = result.accounts.first else {
                    XCTFail("No accounts available")
                    return
                }
                monzo.getBalance(for: account, callback: { (response) in
                    switch response {
                    case .error(let error):
                        XCTFail(error.localizedDescription)
                    case .result(let balance):
                        print(balance.balance)
                        //TODO: Validate balance
                    }
                    outcome.fulfill()
                })
                
            }
        }
        
        waitForExpectations(timeout: timeout) { error in
            if let error = error {
                XCTFail("Expectation error: \(error)")
            }
        }
    }
    
}
