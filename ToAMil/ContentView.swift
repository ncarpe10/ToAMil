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
            Color.green.ignoresSafeArea()
            VStack{
                    Image("Money Emoji")
                    Text("Welcome to ToAMil")
                        .font(.custom(
                            "AmericanTypewriter",
                            size: 35)
                            .weight(.heavy))
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
    @State public var speed = 18.0
    @State private var isEditing = false
    @State private var selection = "No"
    let Choices = ["No", "Yes"]
    
    
    var core = Core()
    var body: some View{
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.green, .white]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            VStack{
                Spacer()
                Image("MainImage")
                    .resizable()
                    .frame(width: 300.0, height: 360.0)
               Spacer()
                HStack{
                   Text("Invest \n$" + String(core.FuncSwitcher(Inflation: selection, Age: Int(speed))) + "\na month to have a Mil by retirement!")
                        .font(.largeTitle)
                }
                
                HStack{
                    Text("Age = " + String(Int(speed)))
                    Slider(value: $speed,
                        in: 1...66,
                        onEditingChanged: { editing in
                            isEditing = editing
                            }
                            )
                    .frame(width: 300, height: 50)
                    
                }
                Spacer()
                HStack{
                    Text("Adjust for inflation: ")
                    Picker("", selection: $selection) {
                                    ForEach(Choices, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.menu)
                }
           
            }
     
                    }
    }
}


struct Core{
    let SPReturn: Double = 0.107
    let TargetAmount: Double = 1000000.0
    let RetirementAge: Double = 67.0
    let InflationRate: Double = 0.0327
    
    
    func MonthlySavings(Age: Int) -> Double{
        let YearsToRetirement = RetirementAge -  Double(Age)
        var result = (TargetAmount * (SPReturn / 12))
        let TMP = result
        let RHS = (pow((1.0 + (SPReturn / 12)),(YearsToRetirement * 12)) - 1)
        result = round((TMP / RHS) * 100) / 100.0
        
        return result
    }
    func MonthlySavings(Age: Int, NewAmount: Double) -> Double{
        let YearsToRetirement = RetirementAge -  Double(Age)
        var result = (NewAmount * (SPReturn / 12))
        let TMP = result
        let RHS = (pow((1.0 + (SPReturn / 12)),(YearsToRetirement * 12)) - 1)
        result = round((TMP / RHS) * 100) / 100.0
        
        return result
    }
    
    
    
    func MonthlySavingWithInflation(Age: Int) -> Double{
        return MonthlySavings(Age: Age, NewAmount: CompoundingInflation(Amount: 1000000.0, Time: Age))          //Hard coding 1,000,000 for now
    }
    
    func CompoundingInflation(Amount: Double, Time: Int) -> Double{
        let YearsToRetirement = RetirementAge -  Double(Time)
        return Amount * pow((1.0 + (InflationRate / 12)),(12.0 * YearsToRetirement))
    
    }
    
    func FuncSwitcher(Inflation: String, Age: Int) -> Double{
        if Inflation == "No"{
            return MonthlySavings(Age: Age)
        }else{
            return MonthlySavingWithInflation(Age: Age)
        }

    }
    

}
