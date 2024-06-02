//
//  ContentView.swift
//  Linear Programming FYP
//
//  Created by Isaac Lee on 28/01/2024.
//

import SwiftUI

struct ContentView: View {
    @Namespace var namespace
    @State var show = false
    
    
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                // This part of the code is credited to author Meng To [12]
                // The GUI as well as the animation are inspired by him, but the photos used are sourced by the undertaker of this project, titles are also changed to fit the name of this project.
                
                
                // state where the card is not expanded
                if !show{
                    VStack{
                        Spacer()
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Linear Programming")
                                .font(.largeTitle.weight(.bold))
                                .matchedGeometryEffect(id: "title", in: namespace)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Simplex Method".uppercased())
                                .font(.footnote.weight(.semibold))
                                .matchedGeometryEffect(id: "subtitle", in: namespace)
                            Text("Master the simplex method through visualisation")
                                .font(.footnote)
                                .matchedGeometryEffect(id: "text", in: namespace)
                        }
                        .padding(20)
                        .background(
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                .blur(radius: 30)
                                .matchedGeometryEffect(id: "blue", in: namespace)
                        )
                        
                    }
                    
                    .foregroundStyle(.white)
                    .background(
                        Image("Illustration 1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .matchedGeometryEffect(id: "image", in: namespace)
                    )
                    .background(
                        Image("Image 2")
                            .resizable()
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                            .matchedGeometryEffect(id: "background", in: namespace)
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: 30, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                            .matchedGeometryEffect(id: "mask", in: namespace)
                    )
                    .frame(height: 300)
                    .padding(20)
                }
                // state where the card is expanded
                else{
                    ScrollView {
                        VStack{
                            Spacer() //takes the maximum height but not width
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    
                        .frame(height: 500)
                        
                        .foregroundColor(.black)
                        .background(
                            Image("Illustration 1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .matchedGeometryEffect(id: "image", in: namespace)
                        )
                        .background(
                            Image("Image 2")
                                .resizable()
                                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                                .matchedGeometryEffect(id: "background", in: namespace)
                        )
                        .mask( // mask after background, clips the content
                            RoundedRectangle(cornerRadius: 30, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                                .matchedGeometryEffect(id: "mask", in: namespace)
                        )
                        .overlay(
                            VStack(alignment: .leading, spacing: 12){
                                Text("Linear Programming")
                                    .font(.largeTitle.weight(.bold))
                                    .matchedGeometryEffect(id: "title", in: namespace)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Simplex Method".uppercased())
                                    .font(.footnote.weight(.semibold))
                                    .matchedGeometryEffect(id: "subtitle", in: namespace)
                                Text("Master the simplex method through visualisation")
                                    .font(.footnote)
                                    .matchedGeometryEffect(id: "text", in: namespace)
                                Divider()
                                HStack{
                                    Image(systemName: "person")
                                        .resizable()
                                        .frame(width: 26, height: 26)
                                        .cornerRadius(10)
                                        .padding(8)
                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    //                                    .strokeStyle(cornerRadius: 18)
                                    HStack {
                                        Text("Taught by Isaac")
                                            .font(.footnote)
                                        
                                        Spacer()
                                        
                                        NavigationLink(destination:LinearConstraintInputView()) {
                                            Text("Begin")
                                        }
                                    }
                                }
                            }
                                .padding(20)
                                .background(
                                    Rectangle()
                                        .fill(.ultraThinMaterial)
                                        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                                        .matchedGeometryEffect(id: "blue", in: namespace)
                                )
                                .offset(y:250)
                                .padding(20)
                        )
                    }
                }
            }
            .background(Image("Image 1"))
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    show.toggle()
                }
            }
        }

       
    }
    
    
    
    
    
    
 
}

#Preview {
    ContentView()
}
