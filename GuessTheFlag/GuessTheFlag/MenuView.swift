//
//  MenuView.swift
//  GuessTheFlag
//
//  Created by Gorkem Turan on 26.12.2022.
//

import SwiftUI

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.1, green: 0.2, blue: 0.45))
            .font(.title)
            .foregroundColor(.white)
    }
}



struct MenuView: View {
    @Binding var buttonPressed : Bool
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Spacer()
                Title()
                Spacer()
                Spacer()
                Button("Start the game!",
                       action: {
                    print(buttonPressed)
                    buttonPressed.toggle()
                    print(buttonPressed)
                })
                .modifier(ButtonStyle())
                Spacer()
                Spacer()
                Spacer()
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(buttonPressed: .constant(false))
    }
}
