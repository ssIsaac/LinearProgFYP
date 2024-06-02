//
//  q2.swift
//  Linear Programming FYP
//
//  Created by Isaac Lee on 02/04/2024.
//

import SwiftUI

struct q2: View {
    
    // variables that create the typewriter effect
    @State var text: String = ""
    @State var finalText: String = "Welcome to the second and final quiz! In order to complete this tutorial, answer everything below correctly!"
    
    // keeps a count of the amount of times user has made a wrong attempt
    @State var errorCount = 0
    // if answer should be revealed
    @State var reveal = false
    
    @State var tableau = [[String]]()
    @State var tableauCopy = [[String]]()
    
    // Variable to store the answer for these variables
    @State var xVal: (Double,Bool) = (0.0, false) // stores a tuple where the first value represents the x value and boolean true shows that the x value is an assigned value and not the default value
    @State var yVal: (Double,Bool) = (0.0, false)
    @State var sDict: [String:(Double, Bool)] = [:]
    @State var cVal: (Double,Bool) = (0.0, false)
    
    
    // if user answer is correct
    @State var isCorrectX: Bool? = nil
    @State var isCorrectY: Bool? = nil
    @State var isCorrectC: Bool? = nil
    
    // variables to hold user input
    @State var inputX = ""
    @State var inputY = ""
    @State var inputC = ""
    
    let errorText: [String] =
        [
            "Oops! That's not the correct answer. A little hint, find the value of c first!",
            "Unlucky! Another hint, start from the last row!",
            "Awhhh, don't worry, click on \"Answer\" below to reveal the right answers"
        ]
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10.0){
                    
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
                    
                    
                    // computes the first row of the tableau, that is the header x,y,s1,s2...
                    VStack {
                        Grid(alignment:.top, horizontalSpacing: 10, verticalSpacing: 10) {
                            GridRow {
                                Text("x")
                                Text("y")
                                ForEach(tableau.indices.dropLast(), id:\.self){ index in
                                    Text("S" + String(index))
                                }
                                Text("C")
                            }
                            .font(.system(size: 12))
                            //creates the visual of the tableau
                            constructTableau(tab: tableau)
                        }
                        .onAppear {
                            // action to perform when the grid appears
                            tableauCopy = tableau
                            self.constructSDict()
                            self.computeC()
                            self.computeValue()
                            
                        }
                        .background(
                            Rectangle()
                                .fill(.ultraThickMaterial)
                                .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        )
                    }
                    .padding(20)
                    
                    // holds the text fields for user to enter
                    VStack(alignment: .center, spacing: 25.0) {
                        TextField("x value", text: $inputX)
                            .font(.system(size: 13).weight(.bold))
                            .padding(7)
                            .background(
                                isCorrectX == true ? Color.green: (isCorrectX == false ? Color.red : Color.white)
                            )
                            .cornerRadius(20)
                            .padding(2)
                            

                            
                        TextField("y value", text: $inputY)
                            .font(.system(size: 13).weight(.bold))
                            .padding(7)
                            .background(
                                isCorrectY == true ? Color.green: (isCorrectY == false ? Color.red : Color.white)
                            )
                            .cornerRadius(20)
                            .padding(2)
                        
                        TextField("c value", text: $inputC)
                            .font(.system(size: 13).weight(.bold))
                            .padding(7)
                            .background(
                                isCorrectC == true ? Color.green: (isCorrectC == false ? Color.red : Color.white)
                            )
                            .cornerRadius(20)
                            .padding(2)
                    }
                    .foregroundColor(.black)
                    .frame(width: 250, height: 200)
                    .padding(10)
                    .padding(10)
                    .shadow(radius: 20)
                    
                    
                    VStack(alignment: .center, spacing: 15.0) {
        
                        // Check to compare user input values to precomputed answers to check if it is a match
                        Button("Check") {
                            checkInputError()
                        }
                        .padding(8)
                        .background(
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        )

                        // Display of the correct answer
                        HStack{
                            if(reveal){
                                Text("x: " + String(xVal.0))
                                    .font(.system(size: 12).weight(.semibold))
                                Text("y: " + String(yVal.0))
                                    .font(.system(size: 12).weight(.semibold))
                                Text("c: " + String(cVal.0))
                                    .font(.system(size: 12).weight(.semibold))
                            }
                        }
                        
                        // On the third wrong attempt, user has the option to reveal the right answer
                        if (errorCount == 3){
                            Button("Answer"){
                                reveal = true
                            }
                            .padding(8)
                            .background(
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            )
                        }
                        
                        // After all input is correct, user gets directed back to the homepage
                        if(isCorrectX == true && isCorrectY == true && isCorrectC == true){
                            NavigationLink(destination: ContentView()) {
                                Text("Back to HomePage")
                            }
                            .fontWeight(.bold)
                            .background(
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            )
                        }
                    }
                }
            
            

        }
        .background(Image("Image 1"))
        .onAppear(perform: {
            typeWriter()
        })
        
    }
    
    
    // Initialises the slack variables in the dictionary to (0,false)
    func constructSDict(){
        let tableauSize = tableau.count
        for index in (0..<tableauSize){
            sDict["S"+String(index)] = (0,false)
        }
    }
    
    // construct the tablueau using the array of arrays in the tableauViewModel
    func constructTableau(tab: [[String]]) -> some View{
        return ForEach(tab.indices, id:\.self){ row in
            if (row == tab.count-1){
                DottedLineHorizontal()
                    .stroke(style: .init(dash: [20]))
                    .foregroundStyle(.yellow)
                    .frame(height: 1)
                    .gridCellUnsizedAxes(.horizontal)
            }
            GridRow{
                ForEach(tab[row].indices, id:\.self){ col in
                    Text(tab[row][col])
                }
                
            }
            .padding(10)
            .font(.system(size: 12))
        }
    }
    
    // helper function to safely unwrap the string to a double
    func toDouble(s:String) -> Double{
        return Double(s) ?? -0.12321
    }
    
    
    // compute the value of c
    func computeC(){
        if (tableau.count > 0){
            let objectiveFuncRow = tableau.count - 1
            // Assign result value to CVal
            cVal = (toDouble(s: tableau[objectiveFuncRow][tableau[objectiveFuncRow].count-1]), true)
            if (toDouble(s:tableau[objectiveFuncRow][0]) != 0.0){
                xVal = (0,true)
            }
            if (toDouble(s:tableau[objectiveFuncRow][1]) != 0.0){
                yVal = (0,true)
            }
            // starts from index 2 because 0 and 1 are x and y index
            // ends at count-2 because count-1 is the "result" and count-2 is the C val
            for index in (2...tableau[objectiveFuncRow].count-3){
                if (toDouble(s: tableau[objectiveFuncRow][index]) != 0.0){
                    //to overwrite the element starting from index 0 in the array since the index starts from 2
                    sDict["S"+String(index-2)] = (0, true)
                }
            }
        }
    }
    

    // compute the value of x
    func computeX(row:Int){
        // guard to ensure func only runs on a tableau that has data
        if (tableau.count > 0){
            let resultCol = tableau[row].count - 1
            // loop through the s values of a row in the tableau. Index 0 and 1 are x and y, count-1 is the result col and count-2 is the c col
            for index in (2...tableau[row].count-3){
                // if s value is not 0 in that row on the tableau
                if (toDouble(s:tableau[row][index]) != 0){
                    // guard to make sure dictionary with the key exists
                    if let sValue = sDict["S" + String(index-2)]{
                        // if key does not exist, initialise it to (0,false)
                        if !sValue.1{
                            sDict["S" + String(index-2)] = (0,false)
                        }
                        else{
                            // if value of key is not false ie. has been assigned a value
                            if (sValue.1 != false){
                                // result of that row is deducted by the s value
                                tableauCopy[row][resultCol] = String(toDouble(s: tableauCopy[row][resultCol]) - sValue.0)
                            }
                            else{
                                return
                            }
                        }
                    }
                }
            }
            if(xVal.1 == false){
                // if x value on tableau is not 0 but y value is 0
                if (toDouble(s: tableau[row][0]) != 0 && toDouble(s: tableau[row][1]) == 0){
                    // x val is equal to result
                    xVal = (toDouble(s:tableauCopy[row][resultCol]),true)
                }
                // if x value and y value are not 0, but y has been assigned a value already
                else if (toDouble(s: tableau[row][0]) != 0 && yVal.1 == true){
                    // x value equals to result minus y value
                    let x = toDouble(s: tableauCopy[row][resultCol]) - yVal.0
                    xVal = (x,true)
                }
            }
        }
    }
    
    // computing the value of y
    func computeY(row:Int){
        // guard to ensure func only runs on a tableau that has data
        if (tableau.count > 0){
            let resultCol = tableau[row].count - 1
            // loop through the s values of a row in the tableau. Index 0 and 1 are x and y, count-1 is the result col and count-2 is the c col
            for index in (2...tableau[row].count-3){
                // if s value is not 0 in that row on the tableau
                if (toDouble(s:tableau[row][index]) != 0){
                    // guard to make sure dictionary with the key exists
                    if let sValue = sDict["S" + String(index-2)]{
                        // if key does not exist, initialise it to (0,false)
                        if !sValue.1{
                            sDict["S" + String(index-2)] = (0,false)
                        }
                        else{
                            // if value of key is not false ie. has been assigned a value
                            if (sValue.1 != false){
                                // result of that row is deducted by the s value
                                tableauCopy[row][resultCol] = String(toDouble(s: tableauCopy[row][resultCol]) - sValue.0)
                            }
                            else{
                                return
                            }
                        }
                    }
                }
            }
            if (yVal.1 == false){
                // if x value on tableau is 0 but y value is not 0
                if (toDouble(s: tableau[row][0]) == 0 && toDouble(s: tableau[row][1]) != 0){
                    // y val is equal to result
                    yVal = (toDouble(s:tableauCopy[row][resultCol]),true)
                }
                // if x value and y value are not 0, but x has been assigned a value already
                else if (toDouble(s: tableau[row][1]) != 0 && xVal.1 == true){
                    // y value equals to result minus x value
                    let y = toDouble(s: tableauCopy[row][resultCol]) - xVal.0
                    yVal = (y,true)
                }
            }
        }
    }
    
    

    // if it is possible to compute s from the row
    func computeS(row : Int){
        if (tableau.count > 0){
            let resultCol = tableau[row].count-1
            var unassigned = ("",0)
            // if both col x and col y are 0
            if (toDouble(s:tableau[row][0]) == 0 && toDouble(s:tableau[row][1]) == 0){
                // check through all the S values if they have been assigned the value by accessing the boolean var of the tuple
                for index1 in (2...tableau[row].count-3){
                    // if s value is not 0, search sArr to see if value has been assigned
                    if (toDouble(s:tableau[row][index1]) != 0){
                        if let sValue = sDict["S" + String(index1-2)]{
                            // if s value has not been initialised in the dict
                            if !sValue.1{
                                sDict["S" + String(index1-2)] = (0,false)
                            }
                            else{
                                // if value of s has been assigned
                                if (sValue.1 != false){
                                    // result column of the row is deeducted by the s value
                                    tableauCopy[row][resultCol] = String(toDouble(s: tableauCopy[row][resultCol]) - sValue.0)
                                }
                                else{
                                    // if the value of s has not been assigned, add to a variable that keeps track of this unassigned s variable, and the total number of unassigned s variable in the row
                                    unassigned = ("S" + String(index1-2), unassigned.1 + 1)
                                }
//                                
                            }
                        }
                    }
                }
                // if there is more than 1 s value that has not been assigned a value ie false in the tuple, return false
                if (unassigned.1 != 1){
                    return
                }
                // if all values from s1,...,sn that have a non-zero value on the tableau have been assigned a value in the dict ie true in the tuple, the only unassigned s value equals to result minus the other assigned s values
                sDict[unassigned.0] = (toDouble(s:tableauCopy[row][resultCol]),true)
            }
        }
    }
    
    //compute the values for x,y, s and c
    func computeValue(){
        if (tableau.count > 0){
            for row in (0...tableau.count-1){
                computeX(row: row)
                computeY(row: row)
                computeS(row: row)
            }
            print(sDict)
            print(xVal)
            print(yVal)
            print(cVal)
        }
        
    }
    
    // function to increment the count of errorCount variable.  ErrorCount is used to access the errorMessage array as an index to display the error message
    func incrementCount(){
        if (errorCount < errorText.count){
            finalText = errorText[errorCount]
            errorCount += 1
        }
    }
    
    // the typewriter effect is taken from citation key [9]. Most of the code is referred directly, only modification made is the time delay,
    // as well as the error message displayed at each count
    func typeWriter(at position: Int = 0) {
        if (errorCount < 4){
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
        else{
            text = "Awhhh, don't worry, click on \"Answer\" below to reveal the right answers"
        }
    }
    
    // check through user entry, identifying the ones that are correct and incorrect
    func checkInputError(){
            
            if (toDouble(s:inputX) == xVal.0){
                isCorrectX = true
            }
            else{
                isCorrectX = false
            }
            if (toDouble(s:inputY) == yVal.0){
                isCorrectY = true
            }
            else{
                isCorrectY = false
            }
            if (toDouble(s:inputC) == cVal.0){
               isCorrectC = true
            }
            else{
                isCorrectC = false
            }
            if(isCorrectX == false || isCorrectY == false || isCorrectC == false){
                incrementCount()
                typeWriter()
            }
            else if(isCorrectX == true && isCorrectY == true && isCorrectC == true){
                finalText = "Bingo! Well done! You've successfully completed this tutorial!"
                typeWriter()
            }
        
    }
    
    


}



struct q2_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of LinearConstraintRowViewModel
        let tableau = [[String]]()
        // Initialize your TableauView with the model
        q2(tableau: tableau)
    }
}
