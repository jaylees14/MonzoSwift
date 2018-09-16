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
    private var testToken = ""
    private let timeout = 15.0
    private let monzo = Monzo.instance
    
    // MARK: - Test Harness Setup
    override func setUp() {
        // We get the Monzo token from the Info.plist, Travis CI deals with this by using an environment variable and passing as an argument
        // Locally we use a shell script to place the token in the plist during the builds
        if let path = Bundle(for: MonzoSwiftTests.self).path(forResource: "Info", ofType: "plist"), let info = NSDictionary(contentsOfFile: path) as? [String: Any] {
            testToken = info["MonzoToken"] as? String ?? ""
        }
        monzo.setAccessToken(testToken)
    }
    
    //MARK: - Validate Access Token
    func testValidation(){
        let outcome = expectation(description: "Monzo validates access token")
        monzo.validateAccessToken { (response) in
            response.handle(self.fail, { success  in
                XCTAssertTrue(success)
            })
            outcome.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }

    // MARK: - Account Retrieval
    func testGetAccounts(){
        let outcome = expectation(description: "Monzo returns a list of accounts associated with the token")
        monzo.getAllAccounts { (result) in
            result.handle(self.fail, { (accounts) in
                XCTAssert(accounts.accounts.count >= 0)
            })
            outcome.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    // MARK: - Account Balance
    func testGetBalance(){
        let outcome = expectation(description: "Monzo returns a list of accounts associated with the token")
        //FIXME: Extract this to a "MockAccount" class
        monzo.getAllAccounts { (accountResponse) in
            accountResponse.handle(self.fail, { (accounts) in
                guard let account = accounts.accounts.first else {
                    XCTFail("No accounts available")
                    return
                }
                self.monzo.getBalance(for: account, callback: { (response) in
                    response.handle(self.fail, { (balance) in
                        print(balance.balance)
                        //TODO: Validate balance
                    })
                    outcome.fulfill()
                })
            })
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testGetTransactions(){
        let outcome = expectation(description: "Monzo returns a list of accounts associated with the token")
        //FIXME: Extract this to a "MockAccount" class
        monzo.getAllAccounts { (accountResponse) in
            accountResponse.handle(self.fail, { (accounts) in
                guard let account = accounts.accounts.first else {
                    XCTFail("No accounts available")
                    return
                }
                self.monzo.getTransactions(for: account, callback: { (response) in
                    response.handle(self.fail, { (transactions) in
                        assert(transactions.count > 0)
                        //TODO: Validate transactions
                    })
                    outcome.fulfill()
                })
            })
        }
        waitForExpectations(timeout: timeout)
    }
    
    func testGetTransaction(){
        let outcome = expectation(description: "Monzo returns the first transaction from the account")
        monzo.getAllAccounts { (accountResponse) in
            accountResponse.handle(self.fail, { (accounts) in
                guard let account = accounts.accounts.first else {
                    XCTFail("No accounts available")
                    return
                }
                self.monzo.getTransactions(for: account, callback: { (transactionsResponse) in
                    transactionsResponse.handle(self.fail, { (transactions) in
                        guard let transaction = transactions.first else {
                            XCTFail("No transactions available")
                            return
                        }
                        self.monzo.getTransaction(for: transaction.id, callback: { (response) in
                            response.handle(self.fail, { (transaction) in
                                assert(transaction.amount > 0)
                            })
                            outcome.fulfill()
                        })
                    })
                })
            })
        }
        waitForExpectations(timeout: timeout)
    }

    fileprivate func fail(with error: Error) {
        print("Failed with \(error.localizedDescription)")
        XCTFail(error.localizedDescription)
    }
}
