//
//  MainCoordinatorViewModel.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 03.08.2024.
//

import Foundation
import Combine

class MainCoordinatorViewModel: ObservableObject {
    var navigationPathContainer = NavigationPathContainer()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        configureSubscribers()
    }
}

extension MainCoordinatorViewModel {
    enum ScreenType: Hashable {
        case game(Game)
        case menu
        case leaderboard
    }
    
    func showScreen(_ screen: ScreenType) {
        navigationPathContainer.path.append(screen)
    }
    
    func dismissScreen() {
        navigationPathContainer.removeLast()
    }
}

private extension MainCoordinatorViewModel {
    func configureSubscribers() {
        navigationPathContainer.$path.sink { _ in
            self.objectWillChange.send()
        }.store(in: &cancellables)
    }
}
