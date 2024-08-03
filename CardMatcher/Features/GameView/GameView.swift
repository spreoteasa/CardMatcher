//
//  GameView.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 03.08.2024.
//

import SwiftUI

struct GameView: View {
    @StateObject var viewModel = GameViewModel()
    let game: Game
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    GameView(
        game: .init(
            cardColor: .init(
                blue: 1,
                green: 2,
                red: 3
            ),
            cardSymbol: "•",
            title: "Some game",
            symbols: ["¡","™","£","¢"]
        )
    )
}
