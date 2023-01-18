//
//  GameView.swift
//  GuessTheFlag
//
//  Created by Gorkem Turan on 26.12.2022.
//

import SwiftUI

struct FlagImage: View {
    let flagName : String
    var rotateAmount: Double
    var opacityAmount: Double
    var scaleAmount: Double
    var label: String
    
    var body: some View {
        Image(flagName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 2))
            .shadow(radius: 5)
            .opacity(opacityAmount)
            .scaleEffect(scaleAmount)
            .rotation3DEffect(.degrees(Double(rotateAmount)),
                              axis: (x: 0.0, y: 1.0, z: 0.0))
            .accessibilityLabel(label)
    }
}

struct FlagView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func flagStyle() -> some View {
        self.modifier(FlagView())
    }
}

struct GameView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var score = 0
    @State private var round = 1
    
    @State private var gameOver = false
    @Binding var isGameContinue : Bool
    
    @State private var rotateAmount = 0.0
     @State private var opacityAmount = 1.0
     @State private var scaleAmount = 1.0
    
    @State private var chosenFlag = -1
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Spacer()
                
                Title()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            withAnimation(.easeOut(duration: 1)) {
                                rotateAmount += 360
                            }
                            withAnimation() {
                                opacityAmount -= 0.75
                                scaleAmount -= 0.5
                            }
                        } label: {
                            FlagImage(flagName: countries[number],
                                      rotateAmount: (chosenFlag == number ? rotateAmount : 0),
                                      opacityAmount: (chosenFlag == number ? 1 : opacityAmount),
                                      scaleAmount: (correctAnswer == number ? 1 : scaleAmount),
                                      label: labels[countries[number], default: "Unknown flag"]
                            )
                        }
                    }
                }
                .flagStyle()
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Text("Round: \(round)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game is over", isPresented: $gameOver ) {
            Button("New Game", action: newGame)
            Button("Main Menu", action: toMainMenu)
        } message: {
            Text("Your score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        chosenFlag = number
        if round == 5 {
            gameOver = true
            return
        }
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong!! That's the flag of \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion() {
        round += 1
        chosenFlag = -1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityAmount = 1.0
        rotateAmount = 0.0
        scaleAmount = 1.0
    }
    
    func newGame() {
        score = 0
        round = 1
        gameOver = false
        askQuestion()
        
    }
    
    func toMainMenu() {
        isGameContinue = false
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(isGameContinue: .constant(false))
    }
}
