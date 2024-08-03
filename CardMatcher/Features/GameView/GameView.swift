//
//  GameView.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 03.08.2024.
//

import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    
    var dynamicSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 240 : 180
    }
    
    func isSymbolMatched(_ symbol: String) -> Bool {
        viewModel.solvedSymbols.contains(symbol)
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: dynamicSize))]) {
                ForEach(viewModel.board) { card in
                    Button {
                        viewModel.select(card)
                    } label: {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundStyle(card.isSelected ? .green : .red)
                        .overlay {
                            Text(card.symbol)
                        }
                        .frame(height: dynamicSize)
                }
                    .disabled(isSymbolMatched(card.symbol))
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    GameView(
        viewModel: GameViewModel(
            game: Game(
                cardColor: .init(blue: 1, green: 2, red: 3),
                cardSymbol: "•",
                title: "Some game",
                symbols: ["¡","™","£","¢"]
            )
        )
    )
}
