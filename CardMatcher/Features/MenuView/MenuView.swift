//
//  MenuView.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import SwiftUI

struct MenuView: View {
    @StateObject var viewModel = MenuViewModel()
    let onGameSelect: (Game) -> Void
    
    var buttonWidth: CGFloat {
        UIScreen.main.bounds.width * 0.75
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.games) { game in
                    gameRow(for: game)
                    Divider()
                }
            }
        }
        .background(.mint)
    }
    
    func gameRow(for game: Game) -> some View {
        Button {
            onGameSelect(game)
        } label: {
            HStack {
                Text(game.title)
                Text(game.symbols.joined(separator: ","))
            }
            .frame(maxWidth: buttonWidth)
            
            .padding(16)
            .background(.regularMaterial, in: .rect(cornerRadii: .init(bottomTrailing: 24, topTrailing: 24)))
            
        }
    }
}

#Preview {
    MenuView() {_ in}
}
