//
//  Game.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import Foundation

struct Game: Codable, Identifiable, Hashable {
    let cardColor: CardColor
    let cardSymbol: String
    let title: String
    let symbols: [String]
    
    var id: Int {
        hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(cardColor)
        hasher.combine(cardSymbol)
        hasher.combine(title)
        symbols.forEach { hasher.combine($0) }
    }
}

extension Game {
    enum CodingKeys: String, CodingKey {
        case cardColor = "card_color"
        case cardSymbol = "card_symbol"
        case title, symbols
    }
}
