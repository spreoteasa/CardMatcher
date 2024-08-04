//
//  CardElement.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 04.08.2024.
//

import Foundation

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
