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
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.points, order: .reverse)]
    ) var scores: FetchedResults<Score>
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    topSection
                        .padding(.bottom, 32)
                    mainSection(proxy: proxy)
                }
            }
            .padding(.horizontal, 16)
            .overlay(alignment: .bottom) {
                buttonSection
            }
            .background(.mint)
        }
        .onReceive(viewModel.timer) { _ in
           updateTimer()
        }
        .onChange(of: viewModel.gameControls.didWin) { newValue in
            if newValue {
                addScore()
            }
        }
    }
}

//MARK: - View Components
extension GameView {
    @ViewBuilder
    func mainSection(proxy: GeometryProxy) -> some View {
        if viewModel.gameControls.didWin {
            Text("You win!")
        } else if viewModel.didLose {
            Text("Time out! You lost")
        } else {
            gameBoard(proxy: proxy)
        }
    }
    
    var topSection: some View {
        Group {
            Text("\(viewModel.game.title)")
                .font(.title)
                .fontWeight(.bold)
                .padding([.top, .leading], 16)
            Text("Score: \(viewModel.gameControls.score)")
                .font(.headline)
                .frame(maxWidth: .infinity)
            Text("Time: \(viewModel.gameControls.time)")
        }
    }
    
    func gameBoard(proxy: GeometryProxy) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: isIpad ? 140 : 100, maximum: 240))]) {
            ForEach(viewModel.gameControls.board) { card in
                cardView(for: card, with: proxy)
            }
        }
    }
    
    func cardView(for card: CardElement, with proxy: GeometryProxy) -> some View {
        let customBinding = Binding {
            card.isSelected
        } set: { newValue in
            viewModel.toggleCardSelection(card)
        }
        
        return CardView(isSelected: customBinding, symbol: card.symbol)
            .opacity(isSymbolMatched(card.symbol) ? 0 : 1)
            .disabled(isSymbolMatched(card.symbol) || !viewModel.gameControls.isGameOn)
            .animation(.default, value: isSymbolMatched(card.symbol))
            .frame(width: isIpad ? 140 : 100, height: isLandscape ? proxy.size.height * 0.2 : proxy.size.height * 0.15)
    }
    
    var buttonSection: some View {
        Button {
            viewModel.buttonAction(scores: scores.compactMap({$0 as Score}))
        } label: {
            Text(viewModel.gameControls.isGameOn ? "Restart" : "Start")
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .foregroundStyle(.red)
                .background(.gray, in: .rect(cornerRadius: 12))
                .frame(maxWidth: .infinity)
        }
    }
}

//MARK: - Utils
extension GameView {
    var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var isLandscape: Bool {
        UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
    }
    
    func isSymbolMatched(_ symbol: String) -> Bool {
        viewModel.solvedSymbols.contains(symbol)
    }
    
    func updateTimer() {
        if viewModel.gameControls.time > 0 {
            viewModel.gameControls.time -= 1
        } else if viewModel.gameControls.time == 0 && viewModel.gameControls.isGameOn == true {
            viewModel.didLose = true
        }
    }
    
    func addScore() {
        let score = Score(context: managedObjectContext)
        score.points = Int64(viewModel.gameControls.score)
        score.time = Int64(viewModel.initialTime - viewModel.gameControls.time)
        score.game = viewModel.game.title
        score.symbol = viewModel.game.cardSymbol
        do {
            try managedObjectContext.save()
        } catch {
            print(error)
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
