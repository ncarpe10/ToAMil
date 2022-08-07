//
//  ContentView.swift
//  ToAMil
//
//  Created by Nick on 8/6/22.
//

import SwiftUI

struct EnterPage: View {
    @Binding var clicked: Bool
    @State private var OffSet = CGSize.zero
    
    var body: some View {
        ZStack{
            if clicked == false{
                Color.green.ignoresSafeArea()
            }else{
                Color.white
            }
            VStack{
                    Image("Money Emoji")
                    Text("Welcome to ToAMil")
                        .font(.largeTitle)
                        .padding()
                    Text("Swipe Up to begin")
        
            }
        }
        .offset(x: 0, y:(abs(OffSet.height / 2) * -1.0))
        .opacity(2 - (Double(OffSet.height / 200) * -1.0))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.translation.height < 1{
                        OffSet = gesture.translation
                    }else{
                        OffSet = .zero
                    }
                }
                .onEnded { _ in
                    if OffSet.height < -250{
                        clicked = true
                    }else{
                        OffSet = .zero
                    }
                }
                )                       }
}

struct MainPage: View {
    @State private var Age: String = ""
    @State public var speed = 50.0
    @State private var isEditing = false
    
    var core = Core()
    var body: some View{
        ZStack{
            VStack{
                Text("Save $" + String(core.MonthlySavings(Age: Int(speed))) + " a month to have a Mil by retirement!")
                    .font(.largeTitle)
                    .padding(100)
                Slider(value: $speed,
                       in: 1...66,
                       onEditingChanged: { editing in
                           isEditing = editing
                        }
                   )
                Text("Age = " + String(Int(speed)))
                
            }
            }
    }
}


struct Core{
    let SPReturn: Double = 0.107
    let TargetAmount: Double = 1000000.0
    let RetirementAge: Double = 67.0
    
    
    func MonthlySavings(Age: Int) -> Double{
        let YearsToRetirement = RetirementAge -  Double(Age)
        var result = (TargetAmount * (SPReturn / 12))
        let TMP = result
        let RHS = (pow((1.0 + (SPReturn / 12)),(YearsToRetirement * 12)) - 1)
        result = round((TMP / RHS) * 100) / 100.0
        
        return result
    }
    
    

    }
    

