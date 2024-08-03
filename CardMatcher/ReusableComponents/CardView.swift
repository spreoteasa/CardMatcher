//
//  CardView.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import SwiftUI

struct CardView: View {
    @Binding var isSelected: Bool
    let symbol: String
    
    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundStyle(isSelected ? .green : .red)
                .shadow(radius: 6)
                .overlay {
                    if isSelected {
                        Text(symbol)
                    } else {
                        Image(systemName: "moonphase.waxing.crescent")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(.white)
                    }
                    
                }
                .rotation3DEffect(.degrees(isSelected ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .animation(.default.speed(0.5), value: isSelected)
        }
        
    }
}

#Preview {
    CardView(
        isSelected: .constant(false),
        symbol: "🥸"
    )
}
