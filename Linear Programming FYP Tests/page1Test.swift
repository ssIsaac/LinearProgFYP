//
//  page1Test.swift
//  Linear Programming FYP
//
//  Created by Isaac Lee on 11/04/2024.
//

import XCTest
@testable import Linear_Programming_FYP

final class page1Test: XCTestCase {

    // all syntax and format of testings are taught by citation key [6]
    // exact implementation is written by the undertaker of this project

    
    
    func testInvalidEntry() {
        let linearConstraintModel = LinearConstraintModel(x: "1", arithOp: "+", y: "3", compareOp: "<=", result: "b")
        
        XCTAssertFalse(linearConstraintModel.isFilled())
    }
    
    func testValidEntry() {
        let linearConstraintModel = LinearConstraintModel(x: "1", arithOp: "+", y: "3", compareOp: "<=", result: "3")
        
        XCTAssertTrue(linearConstraintModel.isFilled())
    }
    
    
    func testNumRows() {
        let linearConstraintRowViewModel = LinearConstraintRowViewModel()
        
        let rows = 3
        
        linearConstraintRowViewModel.constructArr(num: rows)
        let arrSize = linearConstraintRowViewModel.contentLinear.count
        let expected = 3
        
        XCTAssertEqual(arrSize, expected)
    }
    
    
    func testEmptyArr() {
        let linearConstraintRowViewModel = LinearConstraintRowViewModel()
        
        linearConstraintRowViewModel.constructArr(num: 5)
        
        XCTAssertFalse(linearConstraintRowViewModel.isAllFilled())
        
    }
    
    func testFilledArr() {
        let linearConstraintRowViewModel = LinearConstraintRowViewModel()
        

        let entry1 = LinearConstraintModel(x: "1", arithOp: "+", y: "3", compareOp: "<=", result: "3")
        let entry2 = LinearConstraintModel(x: "1", arithOp: "-", y: "5", compareOp: ">=", result: "5")
        linearConstraintRowViewModel.contentLinear.append(entry1)
        linearConstraintRowViewModel.contentLinear.append(entry2)
        
        XCTAssertTrue(linearConstraintRowViewModel.isAllFilled())
    }
     

    func testValidObjFuncEntry() {
        let objFunc = ObjectiveFunctionModel(x: "1", arithOp: "+", y: "2")
        
        XCTAssertTrue(objFunc.isAllObjFilled())
    }

    
    func testInvalidObjFuncEntry() {
        let objFunc = ObjectiveFunctionModel(x: "1", arithOp: "b", y: "2")
        
        XCTAssertFalse(objFunc.isAllObjFilled())
    }
}
