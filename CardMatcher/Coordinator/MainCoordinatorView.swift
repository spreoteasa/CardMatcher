//
//  MainCoordinatorView.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 03.08.2024.
//

import SwiftUI

struct MainCoordinatorView: CoordinatorView {
    @StateObject var viewModel = MainCoordinatorViewModel()
    
    var body: some View {
        navigationContent
    }
}

//MARK: - View Components
extension MainCoordinatorView {
    var navigationContent: some View {
        NavigationStack(path: $viewModel.navigationPathContainer.path) {
            getScreen(.menu)
                .navigationDestination(for: MainCoordinatorViewModel.ScreenType.self) {
                    getScreen($0)
                }
        }
    }
    
    @ViewBuilder
    func getScreen(_ state: MainCoordinatorViewModel.ScreenType) -> some View {
        switch state {
        case .game(let game):
            GameView(viewModel: GameViewModel(game: game))
        case .menu:
            MenuView() { selectedGame in
                viewModel.showScreen(.game(selectedGame))
            }
        }
    }
}


#Preview {
    MainCoordinatorView()
}
