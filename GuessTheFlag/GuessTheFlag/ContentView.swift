//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Gorkem Turan on 26/12/2022.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        RadialGradient(stops: [
            .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
            .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
        ], center: .top, startRadius: 200, endRadius: 700)
        .ignoresSafeArea()
    }
}

struct Title: View {
    var body: some View {
        Text("Guess the Flag")
            .font(.largeTitle.bold())
            .foregroundColor(.white)
    }
}

struct ContentView: View {
    @State private var gameIsOn = false
    
    var body: some View {
        if !gameIsOn {
            MenuView(buttonPressed: $gameIsOn)
        } else {
            GameView(isGameContinue: $gameIsOn)
        }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
