//
//  APIService.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import Foundation

protocol APIService {
    func fetchGames(completion: @escaping ([Game]) -> (Void)) async throws
}

class APIServiceImpl: APIService {
    let path = "https://firebasestorage.googleapis.com/v0/b/concentrationgame-20753.appspot.com/o/themes.json?alt=media&token=6898245a-0586-4fed-b30e-5078faeba078"
    
    func fetchGames(completion: @escaping ([Game]) -> (Void)) async throws {
        guard let url = URL(string: path) else { throw APIError.invalidURL }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else { return }
            let posts = try! JSONDecoder().decode([Game].self, from: data)
            DispatchQueue.main.async {
                completion(posts)
            }
        }.resume()
    }
}
