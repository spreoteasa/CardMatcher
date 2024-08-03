//
//  GameViewModel.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import Foundation
import Combine

@MainActor
class GameViewModel: ObservableObject {
    @Published var board: [CardElement] = []
    @Published var selectedCards: (CardElement?, CardElement?)
    @Published var solvedSymbols: [String] = []
    @Published var isGameOn = false
    @Published var score = 0
    @Published var time = 0
    
    @Published var didWin = false
    private var cancellables = Set<AnyCancellable>()
    let game: Game
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var initialTime: Int {
        game.symbols.count * 5
    }
    
    init(game: Game) {
        self.game = game
        configureSubscribers()
        initializeGame()
    }
    
    private func configureSubscribers() {
        $solvedSymbols.sink { [weak self] newValue in
            self?.didWin = newValue.sorted() == self?.game.symbols.sorted()
        }.store(in: &cancellables)
    }
    
    private func initializeGame() {
        self.board  = game.symbols
            .flatMap({[$0, $0]})
            .shuffled()
            .enumerated()
            .compactMap({CardElement(symbol: $0.element, position: $0.offset, isSelected: true)})
    }
}

//MARK: - Start/Stop Logic
extension GameViewModel {
    func buttonAction() {
        if isGameOn {
            resetGame()
        } else {
            startGame()
        }
    }
    
    private func startGame() {
        board = board.compactMap{CardElement(symbol: $0.symbol, position: $0.position, isSelected: false)}
        self.time = game.symbols.count * 5
        isGameOn = true
    }
    
    private func resetGame() {
        isGameOn = false
        self.time = 0
        selectedCards = (nil, nil)
        solvedSymbols = []
        score = 0
        initializeGame()
    }
}

//MARK: - Card Selection Logic
extension GameViewModel {
    //MARK: - main logic selection method
    func toggleCardSelection(_ card: CardElement) {
        guard let cardIndex = board.firstIndex(of: card), isGameOn else { return }
        
        board[cardIndex].isSelected.toggle()
        
        if handleSelectedCard(card: card) {
            return
        }
        
        if let lhsCard = selectedCards.0, let rhsCard = selectedCards.1 {
            handleMatchingCards(lhsCard: lhsCard, rhsCard: rhsCard, cardIndex: cardIndex)
        }
    }
    //MARK: - Helper methods
    private func handleSelectedCard(card: CardElement) -> Bool {
//        isShowingCard = false
        if let lhs = selectedCards.0, lhs == card {
            selectedCards.0 = nil
            return true
        }
        
        if selectedCards.0 == nil {
            selectedCards.0 = card
            return true
        } else if selectedCards.1 == nil && card != selectedCards.1 && card != selectedCards.0 {
            selectedCards.1 = card
        }
        
        return false
    }

    private func handleMatchingCards(lhsCard: CardElement, rhsCard: CardElement, cardIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self else { return }
            if lhsCard.symbol == rhsCard.symbol {
                self.solvedSymbols.append(lhsCard.symbol)
                self.score += 1
            } else {
                self.deselectCard(at: cardIndex)
                if let leftIndex = board.firstIndex(where: { $0.hashValue == lhsCard.hashValue }) {
                    self.deselectCard(at: leftIndex)
                }
            }
            
            self.selectedCards = (nil, nil)
        }
    }

    private func deselectCard(at index: Int) {
        board[index].isSelected = false
    }
}

import SwiftUI
extension GameViewModel {
    
    struct CardElement: Hashable, Identifiable {
        let symbol: String
        let position: Int
        var isSelected: Bool

        
        var id: Int {
            hashValue
        }
        
        static func ==(lhs: CardElement, rhs: CardElement) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(symbol)
            hasher.combine(position)
        }
    }
}
