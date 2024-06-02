//
//  page2.swift
//  Linear Programming FYP
//
//  Created by Isaac Lee on 15/02/2024.
//

import SwiftUI

struct TableauView: View {
    
    var linearModels: LinearConstraintRowViewModel
    var objModels: ObjectiveFunctionModel
    
    @State var tableauViewModel: TableauViewModel
    @State var tableau: [[String]] = [[]]
    
    //variable to hold the value for the pivot row and pivot column
    @State var pivotRow : Int = 0
    @State var pivotCol : Int = 0
    
    // variables to display pivot value
    @State var pivotColumnDisplay = "NA"
    @State var pivotRowDisplay = "NA"
    @State var pivotValueDisplay = "NA"

    // variables for the typewriter effect
    @State var text: String = ""
    @State var finalText: String = "Try working out the next state of the tableau on your own! The key values are provided to assist you. To verify your answer, tap on \"Compute Row Transformation\"."
    
    // variable to keep track if row transformation can still be applied to the table
    @State var hasConverged : Bool = false
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .center) {
                    
                // Container that holds the image of tutor as well as the speech box
                    VStack(alignment: .leading, spacing: 16.0){
                        HStack {
                            Image("character")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            Text(text)
                                .font(.footnote.weight(.semibold))
                                .background(
                                    Rectangle()
                                        .fill(.ultraThinMaterial)
                                        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .blur(radius: 5)
                                )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 200, alignment: .leading)
                    .padding(20)
                    
                VStack(alignment: .center, spacing: 15) {
                    Grid(alignment:.top){
                        // computes the first row of the tableau, that is the header x,y,s1,s2...
                        GridRow {
                            Text("x")
                            Text("y")
                            ForEach(linearModels.contentLinear.indices, id:\.self){ index in
                                Text("S" + String(index))
                            }
                            Text("C")
                        }
                        .font(.system(size: 12))
                        .padding(10)
                        // actions to perform when the grid row appears
                        .onAppear(perform: {
                            tableau = tableauViewModel.computeTableau(linearModels: linearModels, objModel: objModels)
                            pivotColumnDisplay = String(tableauViewModel.computePivotCol(tableau: tableau)+1)
                            pivotRowDisplay = String(tableauViewModel.computePivotRow(tableau: tableau)+1)
                            pivotValueDisplay = String(tableauViewModel.computePivotValue(tableau: tableau))
                            
                        })
                        
                        // construct the tableau
                        constructTableau(tab: tableau)
                    }
                    .background(
                        Rectangle()
                            .fill(.ultraThickMaterial)
                            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    )
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                }
                .padding(20)
                
                    // Container that holds the display of pivot column, pivot row and pivot value
                    VStack(alignment: .center, spacing: 20) {
                        HStack{
                            Text("Pivot Column:")
                            Text(pivotColumnDisplay)
                        }
                        
                        
                        HStack{
                            Text("Pivot Row: ")
                            Text(pivotRowDisplay)
                        }
                        //
                        HStack{
                            Text("Pivot value: ")
                            Text(pivotValueDisplay)
                            
                        }
                        
                        
                    }
                    .font(.caption)
                    .font(.system(size: 20))
                    .padding(20)
                    
                    VStack(alignment: .center, spacing: 15.0){
                        
                        if(tableau.count == linearModels.contentLinear.count + 1){
                            // Button to apply row transformation function to the tableau
                            Button("Compute Row Transformation") {
                                tableau = tableauViewModel.computeRowTransformation(tableau: tableau, pivotCol: tableauViewModel.computePivotCol(tableau: tableau), pivotRow: tableauViewModel.computePivotRow(tableau: tableau))
                                // if the values have converged, perform the actions below:
                                if (tableauViewModel.hasConverged(tableau: tableau)){
                                    hasConverged = true
                                    pivotColumnDisplay = "Table has converged"
                                    pivotRowDisplay = "Table has converged"
                                    pivotValueDisplay = "Table has converged"
                                    
                                }
                                else{
                                    pivotRow = tableauViewModel.computePivotRow(tableau: tableau)
                                    pivotCol = tableauViewModel.computePivotCol(tableau: tableau)
                                    pivotColumnDisplay = String(pivotRow + 1)
                                    pivotRowDisplay = String(pivotCol + 1)
                                    pivotValueDisplay = String(tableauViewModel.computePivotValue(tableau: tableau))
                                    
                                }
                            }
                            .font(.footnote.weight(.semibold))
                            .cornerRadius(10)
                            .padding(5)
                            .buttonStyle(.bordered)
                            .disabled(hasConverged)
                            
                        }
                        
                    }
                    // If the tableau values have converged, display navigation link to enter next page
                    HStack{
                        if (hasConverged == true){
                            NavigationLink(destination: q2(tableau: tableau)){
                                Image(systemName: "arrow.forward")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width: 20, height: 20)
                                    .cornerRadius(10)
                                    .padding(15)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                            }
                        }
                    }
                
                
                
            }
        }
        .background(content: {
            Image("Image 1")
        })
//        .ignoresSafeArea()
        .onAppear(perform: {
            typeWriter()
        })
        
    }


    
    // construct the tablueau using the array of arrays in the tableauViewModel
    // the concept of displaying an array of arrays using two ForEach loop is
    // inspired by citation key [3]. Only the syntax and usage is taken,
    // the exact implementation is the idea of the undertaker of
    // the project as the situation is different.
    func constructTableau(tab: [[String]]) -> some View{
        return ForEach(tab.indices, id:\.self){ row in
            if (row == tab.count-1){
                DottedLineHorizontal()
                    .stroke(style: .init(dash: [20]))
                    .foregroundStyle(.yellow)
                    .frame(height: 1)
                    .gridCellUnsizedAxes(.horizontal)
            }
            // The use of a for each loop together with a grid row is taken from the
            // idea of citation key [17]. The exact implementation is the
            // idea of the project undertaker, however the core idea is taken from the author.
            GridRow{
                    ForEach(tab[row].indices, id:\.self){ col in
                        Text(tab[row][col])
                    }
                
            }
//            .gridCellColumns(4 + linearModels.contentLinear.count)
//            .scaledToFit()
            .padding(10)
            .font(.system(size: 12))
            
        }
    }
    
    // the typewriter effect is taken from citation key [9]. Most of the code is referred directly, only modification made is the time delay,
    // as well as the error message displayed at each count
    func typeWriter(at position: Int = 0) {
        if position == 0 {
            text = ""
        }
        if position < finalText.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.019) {
                text.append(finalText[position])
                typeWriter(at: position + 1)
            }
        }
    }
    


}
    

// class to represent the tableau
class TableauViewModel: ObservableObject{
    @Published var tableau: [[String]] = []
    @Published var objRow : [String] = []
    @Published var isConverged = false
    
    var linearModels: LinearConstraintRowViewModel
    var objModel: ObjectiveFunctionModel
    
    init(linearModels: LinearConstraintRowViewModel, objModel: ObjectiveFunctionModel) {
        self.linearModels = linearModels
        self.objModel = objModel
    }
    
    // creates the tableau in the form of an array of array, where each row on the tableau is an array.
    func computeTableau(linearModels: LinearConstraintRowViewModel, objModel: ObjectiveFunctionModel) -> [[String]]{
        for index1 in linearModels.contentLinear.indices{
            let temp = linearModels.contentLinear[index1]
            var row = [String]()
            row.append(String(Double(temp.x) ?? 0))
            row.append(String(Double(temp.arithOp + temp.y) ?? 0))
            //construct s value
            for index2 in (0...linearModels.contentLinear.count){
                if (index1==index2){
                    row.append("1.0")
                }
                else {
                    row.append("0.0")
                }
            }
            row.append(String(Double(temp.result) ?? 0))
            tableau.append(row)
        }
        let x = (Double(objModel.x) ?? 0)
        let arithOp = objModel.arithOp
        let y = (Double(objModel.y) ?? 0)
        objRow.append(String(-1*x))
        if (arithOp == "+"){
            objRow.append(String(-1*y))
        }
        else {
            objRow.append(String(y))
        }
        
        for _ in (0..<linearModels.contentLinear.count){
            objRow.append("0.0")
        }
        objRow.append("1.0")
        objRow.append("0.0")
        tableau.append(objRow)
        return tableau
        
    }
    
    //returns the index of the pivot column
    func computePivotCol(tableau: [[String]]) -> Int{
        let lastElem = tableau.count-1
        var column = 0
        var temp = 0.0
        for index in 0..<tableau[lastElem].count-1{
            if ((Double(tableau[lastElem][index]) ?? 0) < temp){
                temp = (Double(tableau[lastElem][index]) ?? 0)
                column = index
            }
        }
        return column
    }
    
    // returns the index of the pivot row
    func computePivotRow(tableau: [[String]]) -> Int {
        let pivotCol = computePivotCol(tableau: tableau)
        var temp = Double(Int.max)
        var row = 0
        for index in tableau.indices{
            let pivotColumnValue = Double(tableau[index][pivotCol]) ?? 0
            let minRowQuotient = (Double(tableau[index][tableau[index].count-1]) ?? 0)/pivotColumnValue
            if (minRowQuotient < temp && minRowQuotient > 0){
                temp = minRowQuotient
                row = index
            }
        }
        return row
    }
    
    // returns the pivot value
    func computePivotValue(tableau: [[String]]) -> Double {
        let pivotCol = computePivotCol(tableau: tableau)
        let pivotRow = computePivotRow(tableau: tableau)
        return Double(tableau[pivotRow][pivotCol]) ?? 0
    }
    
    
    // Applying the transformation function to the existing tableau, returning a new tableau.
    // Theory knowledge is taken from citation [5], lecture notes by Dr Christopher Hampson
    func computeRowTransformation(tableau: [[String]], pivotCol: Int, pivotRow: Int) -> [[String]]{
        var tableauCopy = tableau
        let pivotVal = Double(tableau[computePivotRow(tableau: tableau)][computePivotCol(tableau: tableau)]) ?? 0
        for arrOfArrIndex in tableau.indices{
            for arrIndex in tableau[arrOfArrIndex].indices{
                
                if(arrOfArrIndex == computePivotRow(tableau: tableau)){
                    tableauCopy[arrOfArrIndex][arrIndex] = String(1/pivotVal * (Double(tableau[arrOfArrIndex][arrIndex]) ?? 0)) // formula applied for the pivot row
                }
                else {
                    let const = (Double(tableau[arrOfArrIndex][computePivotCol(tableau: tableau)]) ?? 0)/pivotVal // entry from pivot column/current pivot value
                    let pivotRowVal = Double(tableau[computePivotRow(tableau: tableau)][arrIndex]) ?? 0 // pivot row value
                    tableauCopy[arrOfArrIndex][arrIndex] = String((Double(tableau[arrOfArrIndex][arrIndex]) ?? 0) - (const*pivotRowVal)) // Ri - (current Ri valu/current pivot value)*Rpivot
                }
            }
        }
        return tableauCopy
    }
    
    // check if the objective function row of the tableau contains any negative number
    func containsNegative(tableau: [[String]]) -> Bool {
        let lastElem = tableau.count-1
        for index in 0..<tableau[lastElem].count-1{
            if ((Double(tableau[lastElem][index])) ?? 0 < 0){
                return true
            }
        }
        return false
    }
    
    

// check if the values in the table have converged
    func hasConverged (tableau: [[String]]) -> Bool{
        if (!containsNegative(tableau: tableau)){
            isConverged = true
        }
        return isConverged
    }
}





struct TableauView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of LinearConstraintRowViewModel
        let linearConstraintRowViewModel = LinearConstraintRowViewModel()
        let objFunctionModel = ObjectiveFunctionModel(x:"", arithOp: "", y:"")
        let tableauViewModel = TableauViewModel(linearModels: linearConstraintRowViewModel, objModel: objFunctionModel)
        let tableau = [[String]]()
        // Initialize your TableauView with the model
        TableauView(linearModels: linearConstraintRowViewModel, objModels: objFunctionModel, tableauViewModel: tableauViewModel, tableau: tableau)
    }
}





