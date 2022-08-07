//
//  ToAMilApp.swift
//  ToAMil
//
//  Created by Nick on 8/6/22.
//

import SwiftUI

@main
struct ToAMilApp: App {
    @State var clicked = false
    var body: some Scene {
        WindowGroup {
            if clicked == false{
                EnterPage(clicked: $clicked)
            }else{
                MainPage()
            }
            
        }
    }
}


