//
//  page1.swift
//  Linear Programming FYP
//
//  Created by Isaac Lee on 08/02/2024.
//

import SwiftUI



struct LinearConstraintInputView: View {
    @State var numVar: String = "" // stores the number of variables that user wishes to input
    @State var alertInput = false // boolean variable that turns true if the wrong input format is given by user
    
    @StateObject var linearConstraintRowViewModel = LinearConstraintRowViewModel()
    @StateObject var objFunctionModel = ObjectiveFunctionModel(x: "", arithOp: "", y: "")
    
    
    
    
    
    var body: some View {
        ZStack(alignment: .center){
            ScrollView{
                VStack(alignment: .center){
                    
                    // Container responsible for holding the text field that prompts user to enter the number of linear constraint they would like to enter
                    VStack(alignment:.leading , spacing: 5.0, content: {
                        TextField("Input number of linear constraints", text: $numVar)
                            .textFieldStyle(.roundedBorder)
                            .scaledToFit()
                        
                    })
                    .cornerRadius(20)
                    .shadow(radius: 15)
                    .padding([.top],60)
                    .padding(20)
                    // action to be executed when there is a change in numVar value
                    .onChange(of: numVar) { old, new in
                        alertInput = !validateInput(val: new)
                        linearConstraintRowViewModel.constructArr(num: Int(numVar) ?? 0)
                    }
                    // throws an alert when the wrong input format is detected
                    // the implementation of the alert is done with reference to citation key [7].
                    // There is no modification done as this feature is fairly straightforward to throw a warning, other than the error message.
                    .alert(isPresented: $alertInput, content: {
                        numVar = ""
                        return Alert(title: Text("Invalid Input"))
                    })
                    
                    // Container for holding the input text fields for the linear constraints and objective functions
                    VStack(alignment: .center, spacing: 50){
                        // Upon entering the number of linear constraints into numVar, perform actions below:
                        if (numVar != ""){
                            VStack(content: {
                                // Header for the linear constraint textfields
                                Text("Linear Constraint")
                                    .fontDesign(.serif)
                                    .font(.system(size: 20).weight(.bold))
                                    .textFieldStyle(.roundedBorder)
                                // function call to bring the text fields to view
                                constructRow()
                                
                            })
                            
                            VStack(content: {
                                // Header for the objective function textfields
                                Text("Objective function")
                                    .fontDesign(.serif)
                                    .font(.system(size: 20).weight(.bold))
                                    .textFieldStyle(.roundedBorder)
                                
                                // Embed a HStack within a list that creates three textfields for users to input the x value, y value and arithmetic operator for the objective function
                                List {
                                    HStack(alignment: .center, spacing: 15.0) {
                                        TextField("x value", text: $objFunctionModel.x)
                                        TextField("+ -", text: $objFunctionModel.arithOp)
                                        TextField("y value", text: $objFunctionModel.y)
                                    }
                                    
                                    
                                }
                                .cornerRadius(20)
                                .shadow(radius: 15)
                                .frame( height: 100, alignment: .center)
                                
                                
                            })

                            
                            // When all text fields have been filled in, display an arrow that allows the user to navigate to the next page
                            if(linearConstraintRowViewModel.isAllFilled() && objFunctionModel.isAllObjFilled()){
                                NavigationLink(destination: q1(linearModels: linearConstraintRowViewModel, objModels: objFunctionModel)) {
                                    Image(systemName: "arrow.forward")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .cornerRadius(10)
                                        .padding(15)
                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                                        .padding(20)
                                }
                                
                                
                            }
                            
                        }
                    // Whenever there is a change in numVar value, call the constructArr method using the new numVar value as input
                    }
                    .onChange(of: numVar) {
                        linearConstraintRowViewModel.constructArr(num: Int(numVar) ?? 0)
                    }
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .cornerRadius(15)
                    .shadow(radius: 15)
                    .padding()
                }
                
            }
            
        }
        .background(content: {
            Image("Image 1")
        })
    }
    
    // builds the view to display the linear constraint input rows
    func constructRow() -> some View{
        return List{
            // the usage of a ForEach loop is taught by Paul Hudson [6], but its implementation in this
            // project is done by the undertaker of the project.
            ForEach(linearConstraintRowViewModel.contentLinear.indices, id:\.self){ index in
                LinearConstraintRowView(linearConstraintModel: $linearConstraintRowViewModel.contentLinear[index])
            }
        }
        .cornerRadius(20)
        .shadow(radius: 15)
        .frame(width: .infinity, height: 220, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    // Ensure that the numVar adheres to the regex format below, returns true if it follows
    func validateInput(val:String) -> Bool {
        return val.range(of: "^-?[0-9]*$", options: .regularExpression) != nil
    }
    


    
}


// class responsible for storing eash liner constraint entry
class LinearConstraintModel: ObservableObject {
    
    // variables for storing each textfield entry
    // The interaction between the linear constraint model class and other classes is inspired by
    // citation key [14] to handle user input data for the linear constraint using ObservableObject
    // and @Published. Only the idea is taken
    // from the author, and the exact implementation is by the undertaker of this project
    @Published var x: String
    @Published var arithOp: String
    @Published var y: String
    @Published var compareOp: String
    @Published var result: String
    
    
    // Constructor for initialising the variables
    init(x: String, arithOp: String, y: String, compareOp: String, result: String) {
        self.x = x
        self.arithOp = arithOp
        self.y = y
        self.compareOp = compareOp
        self.result = result
    }
    
    // returns true if all variables have been assigned a correct value and none left empty
    func isFilled() -> Bool{
        if (validateX(val:x)){
            if (validateArithOp(val:arithOp)){
                if (validateY(val:y)){
                    if(validateCompareOp(val:compareOp)){
                        if (validateResult(val:result)){
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    
    // function to ensure the right input format is given (empty string is not accepted)
    // the regex is taken from author Sulthan on StackOverflow with citation key [13], for the
    // inputs that only accept integers. For functions that acceot inequality signs
    // and arithmetic operator is ammended by the undertaker of the project
    func validateX(val:String) -> Bool {
        return val.range(of: "^-?[0-9]+$", options: .regularExpression) != nil
    }
    
    func validateArithOp(val:String) -> Bool {
        return val.range(of: "^[\\+\\-]$", options: .regularExpression) != nil
    }
    
    func validateY(val:String) -> Bool {
        return val.range(of: "^-?[0-9]+$", options: .regularExpression) != nil
    }
    
    func validateCompareOp(val:String) -> Bool {
        return val.range(of: "^[<|<=|>|>=]+$", options: .regularExpression) != nil
    }
    
    func validateResult(val:String) -> Bool {
        return val.range(of: "^[0-9]+$", options: .regularExpression) != nil
    }
    
    
    
    // function to ensure the right input format is given (empty string is accepted)
    func validateX1(val:String) -> Bool {
        return val.range(of: "^-?[0-9]*$", options: .regularExpression) != nil
    }
    
    func validateY1(val:String) -> Bool {
        return val.range(of: "^-?[0-9]*$", options: .regularExpression) != nil
    }
    
    func validateArithOp1(val:String) -> Bool {
        return val.range(of: "^[\\+\\-]*$", options: .regularExpression) != nil
    }
    
    func validateCompareOp1(val:String) -> Bool {
        return val.range(of: "^[<|<=|>|>=|=]*$", options: .regularExpression) != nil
    }
    
    func validateResult1(val:String) -> Bool {
        return val.range(of: "^[0-9]*$", options: .regularExpression) != nil
    }
    
    
    
}


// central management system that keeps stores all linear constraint models into an array
class LinearConstraintRowViewModel: ObservableObject {
    @Published var contentLinear: [LinearConstraintModel] = []
    
    
    
    // construct rows with empty string value for each variable
    func constructArr(num:Int){
        self.contentLinear = []
        for _ in (0..<num){
            self.contentLinear.append(LinearConstraintModel(x: "", arithOp: "", y: "", compareOp: "", result: ""))
        }
    }
    
    // checks if every single linaer constraint model is filled in, true if yes
    func isAllFilled() -> Bool{
        let x = contentLinear.count
        var y = 0
        for temp in (contentLinear){
            if (temp.isFilled()){
                y += 1
            }
        }
        if (x == y){
            return true
        }
        return false
    }
    
}




// View struct for the linear constraint models
struct LinearConstraintRowView: View {
    // Creates a binding to the linear constraint model class to directly modify the variables of that class
    // The interaction between the linear constraint row view struct and other classes is inspired by
    // citation key [14] to handle user input data using @Binding. Only the idea is taken
    // from the author, and the exact implementation is by the undertaker of this project
    @Binding var linearConstraintModel: LinearConstraintModel
    
    // boolean variables to ensure input adheres to the correct format
    @State var alertX = false
    @State var alertArithOp = false
    @State var alertY = false
    @State var alertCompareOp = false
    @State var alertResult = false
    
    var body: some View {
        
        // Textfields for users to input the linear constraints, throws warning for the wrong input format
        HStack(alignment: .center, spacing: 15.0) {
            TextField("x value", text: $linearConstraintModel.x)
                .onChange(of: linearConstraintModel.x) { old, new in
                    alertX = !linearConstraintModel.validateX1(val: new)
                }
                .alert(isPresented: $alertX, content: {
                    linearConstraintModel.x = ""
                    return Alert(title: Text("Invalid Input"))
                })
            
            TextField("+ -", text: $linearConstraintModel.arithOp)
                .onChange(of: linearConstraintModel.arithOp) { old, new in
                    alertArithOp = !linearConstraintModel.validateArithOp1(val: new)
                }
                .alert(isPresented: $alertArithOp, content: {
                    linearConstraintModel.arithOp = ""
                    return Alert(title: Text("Invalid Input"))
                })
            
            TextField("y value", text: $linearConstraintModel.y)
                .onChange(of: linearConstraintModel.y) { old, new in
                    alertY = !linearConstraintModel.validateY1(val: new)
                }
                .alert(isPresented: $alertY, content: {
                    linearConstraintModel.y = ""
                    return Alert(title: Text("Invalid Input"))
                })
            
            TextField("= <= >= < >", text: $linearConstraintModel.compareOp)
                .onChange(of: linearConstraintModel.compareOp) { old, new in
                    alertCompareOp = !linearConstraintModel.validateCompareOp1(val: new)
                }
                .alert(isPresented: $alertCompareOp, content: {
                    linearConstraintModel.compareOp = ""
                    return Alert(title: Text("Invalid Input"))
                })
            
            TextField("result", text: $linearConstraintModel.result)
                .onChange(of: linearConstraintModel.result) { old, new in
                    alertResult = !linearConstraintModel.validateResult1(val: new)
                }
                .alert(isPresented: $alertResult, content: {
                    linearConstraintModel.result = ""
                    return Alert(title: Text("Invalid Input"))
                })
        }
    }
}


// objective function class to store the obkective function
class ObjectiveFunctionModel: LinearConstraintModel{
    
    init(x: String, arithOp: String, y: String) {
        super.init(x: x, arithOp: arithOp, y: y, compareOp: "", result: "")
    }
    
    // check that all variables are assigned a value, true if all is assigned.
    func isAllObjFilled() -> Bool{
        if (validateX(val:x)){
            if (validateArithOp(val:arithOp)){
                if (validateY(val:y)){
                    return true
                }
            }
        }
        return false
    }
}





#Preview {
    LinearConstraintInputView()
}



