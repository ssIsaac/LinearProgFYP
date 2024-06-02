//
//  q1.swift
//  Linear Programming FYP
//
//  Created by Isaac Lee on 31/03/2024.
//

import SwiftUI

struct q1: View {
    // variables that create the typewriter effect
    @State var text: String = ""
    @State var finalText: String = "Hey! Welcome to the first quiz! Before we proceed, please select the right answer below carefully!"
    
    // keeps a count of the amount of times user has made a wrong attempt
    @State var errorCount = 0
    
    // keeps track of each button state
    @State var button0 = false
    @State var button1 = false
    @State var button2 = false
    @State var button3 = false
    
    var linearModels: LinearConstraintRowViewModel
    var objModels: ObjectiveFunctionModel
    
    
    // error message to be displayed
    let errorText: [String] =
        [
            "Oops! That's not the correct answer, try again!",
            "Unlucky! Give it another shot!",
            "Awhhh, don't worry, here's the answer! Better luck next time!"
        ]
    
    
    
    
    var body: some View {
        
        ZStack(alignment: .topLeading){
            VStack(alignment: .center, spacing: 16.0){
                
                Spacer()
                
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
                
                Spacer()
                
                // Holds the answers for the multiple choice questions
                VStack(alignment: .leading, spacing: 25.0){
                    
                    // The correct answer. Once selected, disables all other buttons
                    Button("A. Introduce slack form and cost equation") {
                        finalText = "Bingo! This is indeed the right answer!"
                        typeWriter()
                        button0 = true
                        button1 = true
                        button2 = true
                        button3 = true
                    }
                    .padding(10)
                    .fontDesign(.serif)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .background(button0 ? Color.green: Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .disabled(button0)
                        
                    // Incorrect answer, once selected, turns red and disables itself so it cannot be selected again
                    Button("B. Fit everything into a tableau") {
                        incrementCount()
                        typeWriter()
                        button1 = true
                    }
                    .padding(10)
                    .fontDesign(.serif)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .background(button1 ? Color.red: Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .disabled(button1)
                    
                    Button("C. Identify the most negative column") {
                        incrementCount()
                        typeWriter()
                        button2 = true
                    }
                    .padding(10)
                    .fontDesign(.serif)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .background(button2 ? Color.red: Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .disabled(button2)
                    
                    Button("D. None of the above") {
                        incrementCount()
                        typeWriter()
                        button3 = true
                    }
                    .padding(10)
                    .fontDesign(.serif)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .background(button3 ? Color.red: Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .disabled(button3)
                    
                }
                .padding(30)
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                
                // If option A the right answer is selected, reveal navigation link for user to proceed to the next page.
                VStack(alignment: .center){
                    if (button0){
                        NavigationLink(destination: TableauView(linearModels: linearModels, objModels: objModels, tableauViewModel: TableauViewModel(linearModels: linearModels, objModel: objModels), tableau: [[]])) {
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
                .padding(20)
                
                Spacer()
            }
            
            
            
        }
        .background(content: {
            Image("Image 1")
        })
        .onAppear(perform: {
            typeWriter()
        })
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

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

struct q1_Previews: PreviewProvider {
    static var previews: some View {
        let linearModels = LinearConstraintRowViewModel()
        let objFunctionModel = ObjectiveFunctionModel(x:"", arithOp: "", y:"")
        q1(linearModels: linearModels, objModels: objFunctionModel)
    }
}

//#Preview {
//    q1()
//}
