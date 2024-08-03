//
//  MenuViewModel.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import Foundation

@MainActor
class MenuViewModel: ObservableObject {
    @Published var games: [Game] = []
    
    let apiService: APIService
    
    init(apiService: APIService = APIServiceImpl()) {
        self.apiService = apiService
        
        fetchGames()
    }
    
    func fetchGames() {
        Task { [weak self] in
            guard let self else { return }
            do {
                self.games = try await self.apiService.fetchGames()
            } catch {
                print(error)
            }
        }
    }
}
