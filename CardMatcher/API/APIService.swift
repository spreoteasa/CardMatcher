//
//  APIService.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import Foundation
import PISAPI

protocol APIService {
    func fetchGames() async throws -> [Game]
}

class APIServiceImpl: APIService {
    let apiService = PISAPIImpl()
    
    func fetchGames() async throws -> [Game] {
        let request = FetchGameRequest()
        return try await apiService.request(request)
    }
}
