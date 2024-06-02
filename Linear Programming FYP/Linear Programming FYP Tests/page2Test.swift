//
//  page2Test.swift
//  Linear Programming FYP Tests
//
//  Created by Isaac Lee on 11/04/2024.
//

import XCTest
                                                                                                                                                    
final class page2Test: XCTestCase {
    // all syntax and format of testings are taught by citation key [6]
    // exact implementation is written by the undertaker of this project

    var tabViewModel: TableauViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        let  linConstraints = [
            LinearConstraintModel(x: "3", arithOp: "+", y: "2", compareOp: "<=", result: "15"),
            LinearConstraintModel(x: "-1", arithOp: "+", y: "2", compareOp: "<=", result: "5"),
            LinearConstraintModel(x: "1", arithOp: "+", y: "2", compareOp: "<=", result: "7")
        ]
        
        let linearModels = LinearConstraintRowViewModel()
        linearModels.contentLinear = linConstraints
        let objModels = ObjectiveFunctionModel(x: "2", arithOp: "+", y: "3")
        tabViewModel = TableauViewModel(linearModels: linearModels, objModel: objModels)
        tabViewModel.tableau = tabViewModel.computeTableau(linearModels: tabViewModel.linearModels, objModel: tabViewModel.objModel)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        tabViewModel = nil
        super.tearDown()
    }
    
    
    func testIsTableauGeneratedCorrect(){
        
        
        
        XCTAssertEqual(tabViewModel.tableau, [["3.0","2.0","1.0","0.0","0.0","0.0","15.0"],
            ["-1.0","2.0","0.0","1.0","0.0","0.0","5.0"],
            ["1.0","2.0","0.0","0.0","1.0","0.0","7.0"],
            ["-2.0","-3.0","0.0","0.0","0.0","1.0","0.0"]])
    }

    func testIsPivotColCorrect(){
        let pivotCol = tabViewModel.computePivotCol(tableau: tabViewModel.tableau)
        let actualPivotCol = 1
        
        XCTAssertEqual(pivotCol, actualPivotCol)
    }
    
    
    func testIsPivotRowCorrect(){
        let pivotRow = tabViewModel.computePivotRow(tableau: tabViewModel.tableau)
        let actualPivotRow = 1
        
        XCTAssertEqual(pivotRow, actualPivotRow)
    }


    func testIsPivotValCorrect(){
        let pivotVal = tabViewModel.computePivotValue(tableau: tabViewModel.tableau)
        let actualPivotVal = 2.0
        
        XCTAssertEqual(pivotVal, actualPivotVal)
    }
    
    
    func testIsTransformationCorrect(){
        let pivotCol = tabViewModel.computePivotCol(tableau: tabViewModel.tableau)
        let pivotRow = tabViewModel.computePivotRow(tableau: tabViewModel.tableau)
        let newTableau = tabViewModel.computeRowTransformation(tableau: tabViewModel.tableau, pivotCol: pivotCol, pivotRow: pivotRow)
        
        let actualTableau = [["4.0","0.0","1.0","-1.0","0.0","0.0","10.0"],
                             ["-0.5","1.0","0.0","0.5","0.0","0.0","2.5"],
                             ["2.0","0.0","0.0","-1.0","1.0","0.0","2.0"],
                             ["-3.5","0.0","0.0","1.5","0.0","1.0","7.5"]]
        
        XCTAssertEqual(newTableau, actualTableau)
        
    }

    func testContainsNegativeTrue(){
        let tableau = [["4","0","1","-1","0","0","10"],
                             ["-0.5","1","0","0.5","0","0","2.5"],
                             ["2","0","0","-1","1","0","2"],
                             ["-3.5","0","0","1.5","0","1","7.5"]]
        
        XCTAssertTrue(tabViewModel.containsNegative(tableau: tableau))
    }
    
    func testContainsNegativeFalse(){
        let tableau = [["4","0","1","-1","0","0","10"],
                             ["-0.5","1","0","0.5","0","0","2.5"],
                             ["2","0","0","-1","1","0","2"],
                             ["3.5","0","0","1.5","0","1","7.5"]]
        
        XCTAssertFalse(tabViewModel.containsNegative(tableau: tableau))
    }
    
    
    
}
