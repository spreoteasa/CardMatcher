//
//  GameViewModel.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import Foundation
import Combine

struct GameControls {
    var board: [CardElement] = []
    var selectedCards: (CardElement?, CardElement?)
    var isGameOn = false
    var score = 0
    var time = 0
    var moves = 0
    var didWin = false
}

@MainActor
class GameViewModel: ObservableObject {
    @Published var gameControls = GameControls()
    @Published var solvedSymbols: [String] = []
    @Published var didLose = false
    
    var isSelectionEnabled: Bool {
        (gameControls.selectedCards.0 == nil || gameControls.selectedCards.1 == nil) ? true : false
    }
    
    private var cancellables = Set<AnyCancellable>()
    let game: Game
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var initialTime: Int {
        game.symbols.count * 5
    }
    
    func initialTime(highScore: Score?) -> Int {
        var computedTime = game.symbols.count * 5
        if let highScore {
            let fastestTime = highScore.time
            let highestScore = highScore.points
            computedTime -= Int(fastestTime/4)
            computedTime -= Int(highestScore/6)
        }
        return computedTime
    }
    
    init(game: Game) {
        self.game = game
        configureSubscribers()
        initializeGame()
    }
    
    private func configureSubscribers() {
        $solvedSymbols.sink { [weak self] newValue in
            guard let self else { return }
            self.gameControls.didWin = newValue.sorted() == self.game.symbols.sorted()
            if self.gameControls.didWin == true {
                self.timer.upstream.connect().cancel()
                self.gameControls.score += (self.initialTime - self.gameControls.time)
                
                if self.gameControls.moves == self.gameControls.board.count {
                    self.gameControls.score += self.gameControls.board.count / 2
                } else if self.gameControls.moves > self.gameControls.board.count && self.gameControls.moves < self.gameControls.board.count + 4 {
                    self.gameControls.score += self.gameControls.board.count / 4
                }
            }
        }.store(in: &cancellables)
        
        $didLose.sink { [weak self] newValue in
            if newValue {
                self?.timer.upstream.connect().cancel()
            }
        }.store(in: &cancellables)
    }
    
    private func initializeGame() {
        self.gameControls.board  = game.symbols
            .flatMap({[$0, $0]})
            .shuffled()
            .enumerated()
            .compactMap({CardElement(symbol: $0.element, position: $0.offset, isSelected: true)})
    }
}

//MARK: - Start/Stop Logic
extension GameViewModel {
    func buttonAction(scores: [Score]) {
        if gameControls.isGameOn {
            resetGame()
        } else {
            if let highestScore = scores.filter({$0.game == game.title}).sorted(by: {$0.points > $1.points}).first {
                startGame(highestScore: highestScore)
            } else {
                startGame(highestScore: nil)
            }
        }
    }
    
    private func startGame(highestScore: Score?) {
        gameControls.board = gameControls.board.compactMap{CardElement(symbol: $0.symbol, position: $0.position, isSelected: false)}
        self.gameControls.time = initialTime(highScore: highestScore)
        gameControls.isGameOn = true
    }
    
    private func resetGame() {
        gameControls.isGameOn = false
        gameControls.time = 0
        gameControls.selectedCards = (nil, nil)
        solvedSymbols = []
        gameControls.score = 0
        initializeGame()
    }
}

//MARK: - Card Selection Logic
extension GameViewModel {
    //MARK: - main logic selection method
    func toggleCardSelection(_ card: CardElement) {
        guard let cardIndex = gameControls.board.firstIndex(of: card), gameControls.isGameOn, isSelectionEnabled else { return }
        gameControls.moves += 1
        gameControls.board[cardIndex].isSelected.toggle()
        
        if handleSelectedCard(card: card) {
            return
        }
        
        if let lhsCard = gameControls.selectedCards.0, let rhsCard = gameControls.selectedCards.1 {
            handleMatchingCards(lhsCard: lhsCard, rhsCard: rhsCard, cardIndex: cardIndex)
        }
    }
    //MARK: - Helper methods
    private func handleSelectedCard(card: CardElement) -> Bool {
        if let lhs = gameControls.selectedCards.0, lhs == card {
            gameControls.selectedCards.0 = nil
            return true
        }
        
        if gameControls.selectedCards.0 == nil {
            gameControls.selectedCards.0 = card
            return true
        } else if gameControls.selectedCards.1 == nil && card != gameControls.selectedCards.1 && card != gameControls.selectedCards.0 {
            gameControls.selectedCards.1 = card
        }
        
        return false
    }

    private func handleMatchingCards(lhsCard: CardElement, rhsCard: CardElement, cardIndex: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self else { return }
            if lhsCard.symbol == rhsCard.symbol {
                self.solvedSymbols.append(lhsCard.symbol)
                self.gameControls.score += 1
            } else {
                self.deselectCard(at: cardIndex)
                if let leftIndex = gameControls.board.firstIndex(where: { $0.hashValue == lhsCard.hashValue }) {
                    self.deselectCard(at: leftIndex)
                }
            }
            
            self.gameControls.selectedCards = (nil, nil)
        }
    }

    private func deselectCard(at index: Int) {
        gameControls.board[index].isSelected = false
    }
}
