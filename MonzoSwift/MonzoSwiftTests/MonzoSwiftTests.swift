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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBalance(){
        let mockAccount = MonzoAccount(id: "123", description: "A mock account", created: "Never")
        let monzo = Monzo.instance
        monzo.getBalance(for: mockAccount) { (result) in
            switch result {
            case .error(let error):
                XCTFail(error.localizedDescription)
            case .result(let balance):
                XCTAssertTrue(balance.balance == 0)
            }
        }
    }
    
}
