//
//  GameView.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 03.08.2024.
//

import SwiftUI

@MainActor
struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
        }
    
    var isLandscape: Bool {
        UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    }
    
    func isSymbolMatched(_ symbol: String) -> Bool {
        viewModel.solvedSymbols.contains(symbol)
    }
    
    var body: some View {
        GeometryReader { proxy in
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                topSection
                    .padding(.bottom, 32)
                if viewModel.didWin {
                    Text("You win!")
                } else {
                    gameBoard(proxy: proxy)
                }
                }
            }
            .padding(.horizontal, 16)
            .overlay(alignment: .bottom) {
                buttonSection
            }
            .background(.mint)
        }
        .onReceive(viewModel.timer) { time in
            if viewModel.time > 0 {
                viewModel.time -= 1
            }
        }
        .onChange(of: viewModel.didWin) { newValue in
            if newValue {
                let score = Score(context: managedObjectContext)
                score.points = Int64(viewModel.score)
                score.time = Int64(viewModel.initialTime - viewModel.time)
                
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}

//MARK: - View Components
extension GameView {
    var topSection: some View {
        Group {
            Text(viewModel.game.title)
                .font(.title)
                .fontWeight(.bold)
                .padding([.top, .leading], 16)
            Text("Score: \(viewModel.score)")
                .font(.headline)
                .frame(maxWidth: .infinity)
            Text("Time: \(viewModel.time)")
        }
    }
    
    func gameBoard(proxy: GeometryProxy) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: isIpad ? 140 : 100, maximum: 240))]) {
            ForEach(viewModel.board) { card in
                cardView(for: card, with: proxy)
            }
        }
    }
    
    func cardView(for card: GameViewModel.CardElement, with proxy: GeometryProxy) -> some View {
        let customBinding = Binding {
            card.isSelected
        } set: { newValue in
            viewModel.toggleCardSelection(card)
        }
        
            return CardView(isSelected: customBinding, symbol: card.symbol)
                .opacity(isSymbolMatched(card.symbol) ? 0 : 1)
                .disabled(isSymbolMatched(card.symbol) || !viewModel.isGameOn)
                .animation(.default, value: isSymbolMatched(card.symbol))
                .frame(width: isIpad ? 140 : 100, height: isLandscape ? proxy.size.height * 0.2 : proxy.size.height * 0.15)
    }
    
    var buttonSection: some View {
        Button(action: viewModel.buttonAction) {
            Text(viewModel.isGameOn ? "Restart" : "Start")
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .foregroundStyle(.red)
                .background(.gray, in: .rect(cornerRadius: 12))
                .frame(maxWidth: .infinity)
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
                symbols: ["¡","™","£","¢", "º", "–"]
            )
        )
    )
}
