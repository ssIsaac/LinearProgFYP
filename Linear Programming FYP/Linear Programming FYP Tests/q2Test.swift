//
//  q2Test.swift
//  Linear Programming FYP Tests
//
//  Created by Isaac Lee on 12/04/2024.
//

import XCTest

final class q2Test: XCTestCase {

    // all syntax and format of testings are taught by citation key [6]
    // exact implementation is written by the undertaker of this project

    var q2View: q2!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        q2View = q2()
        q2View.tableau = [["3","2","1","0","0","0","15"],
                          ["-1","2","0","1","0","0","5"],
                          ["1","2","0","0","1","0","7"],
                          ["-2","-3","0","0","0","1","0"]]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        q2View = nil
        super.tearDown()
    }

    func testSDictConstruction(){
        q2View.constructSDict()
        
        let numEntries = q2View.sDict.count
        let actualEntries = 3
        
        XCTAssertEqual(numEntries, actualEntries)
    }
    
    func testToDouble(){
        let val = q2View.toDouble(s: "1")
        let expectedVal = 1.0
        
        XCTAssertEqual(val, expectedVal)
    }
    
    func testToDoubleSafeUnwrapping(){
        let val = q2View.toDouble(s: "e")
        let expectedVal = -0.12321
        
        XCTAssertEqual(val, expectedVal)
    }
    
    func testComputeC (){
        q2View.computeC()
        let expectedVal = 12.5
        
        XCTAssertEqual(q2View.cVal.0, expectedVal)
    }
    
    func testComputeValue(){
        q2View.computeValue()
        
        let cVal = 12.5
        let xVal = 4.0
        let yVal = 1.5
        
        XCTAssertEqual(q2View.cVal.0, cVal)
        XCTAssertEqual(q2View.xVal.0, xVal)
        XCTAssertEqual(q2View.yVal.0, yVal)
    }
    
    func testErrorMessage(){
        q2View.incrementCount()
        
        let errorMessage = "Oops! That's not the correct answer. A little hint, find the value of c first!"
        
        XCTAssertEqual(q2View.errorText[q2View.errorCount], errorMessage)
        
        q2View.incrementCount()
        let errorMessage1 = "Unlucky! Another hint, start from the last row!"
        XCTAssertEqual(q2View.errorText[q2View.errorCount], errorMessage1)
    }
    
    
}
