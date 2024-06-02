//
//  q1Test.swift
//  Linear Programming FYP Tests
//
//  Created by Isaac Lee on 11/04/2024.
//

import XCTest

final class q1Test: XCTestCase {
    // all syntax and format of testings are taught by citation key [6]
    // exact implementation is written by the undertaker of this project

    var q1View: q1!
    
    override func setUpWithError() throws{
        super.setUp()
        
        let linearModels = LinearConstraintRowViewModel()
        let objModels = ObjectiveFunctionModel(x: "", arithOp: "", y: "")
        q1View = q1(linearModels: linearModels, objModels: objModels)
    }
    
    override func tearDownWithError() throws{
        q1View = nil
        super.tearDown()
    }
    
    func testCorrectErrorMessage() {

        q1View.errorCount = 0
        let errorMessage1 = "Oops! That's not the correct answer, try again!"
        XCTAssertEqual(q1View.errorText[q1View.errorCount], errorMessage1)
        q1View.incrementCount()
        q1View.errorCount = q1View.errorCount + 1
        let errorMessage2 = "Unlucky! Give it another shot!"
        XCTAssertEqual(q1View.errorText[q1View.errorCount], errorMessage2)
        
        
    }
    
    func testWrongErrorMessage(){
        q1View.errorCount = 1
        let errorMessage1 = "Unlucky! Give it another shot!"
        XCTAssertNotEqual(q1View.errorText[q1View.errorCount], errorMessage1)
    }
    
    func testErrorCountDoesNotExceedThree() {
        q1View.errorCount = 3
        q1View.incrementCount()
        XCTAssertEqual( q1View.errorCount, 3)
    }
    
    func testIncrementError() {
        q1View.incrementCount()
        
        XCTAssertEqual(1, q1View.errorCount,  "Error count should increment by 1")
    }
    

}
