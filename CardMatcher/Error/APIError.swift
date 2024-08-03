//
//  APIError.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import Foundation

enum APIError: Error {
    case apiError(code: Int)
    case invalidURL
    case invalidData
}
