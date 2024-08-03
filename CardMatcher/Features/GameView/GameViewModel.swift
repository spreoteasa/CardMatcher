//
//  GameViewModel.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import Foundation

@MainActor
class GameViewModel: ObservableObject {
    let game: Game
    
    var gameBoard: [String: (Int, Int)] = [:]
    
    @Published var board: [CardElement]
    @Published var selectedCards: (CardElement?, CardElement?)
    @Published var solvedSymbols: [String] = [] {
        didSet {
            print(solvedSymbols)
        }
    }
    
    init(game: Game) {
        self.game = game
        self.board  = game.symbols.flatMap({[$0, $0]}).shuffled().enumerated().compactMap({CardElement(symbol: $0.element, position: $0.offset, isSelected: false)})
        createBoard()
    }
    
    func createBoard() {
        var positions: [String: [Int]] = [:]
        
        board.forEach { positions[$0.symbol, default: []].append($0.position) }
        gameBoard = positions.compactMapValues { $0.count == 2 ? ($0[0], $0[1]) : nil }
    }
    
    func select(_ card: CardElement) {
        if let cardIndex = board.firstIndex(of: card) {
            board[cardIndex].isSelected.toggle()
            
            if let lhs = selectedCards.0, lhs == card {
                selectedCards.0 = nil
                return
            }
            
            if selectedCards.0 == nil  {
                selectedCards.0 = card
                return
            } else if selectedCards.1 == nil && card != selectedCards.1 && card != selectedCards.0 {
                selectedCards.1 = card
            }
            
            if let lhs = selectedCards.0, let rhs = selectedCards.1 {
                if lhs.symbol == rhs.symbol {
                    solvedSymbols.append(lhs.symbol)
                } else {
                    board[cardIndex].isSelected = false
                    if let leftIndex = board.firstIndex(where: {
                        $0.hashValue == lhs.hashValue
                    }) {
                        board[leftIndex].isSelected = false
                    }
                }
                
                selectedCards.0 = nil
                selectedCards.1 = nil
            }
        }
    }
}

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
