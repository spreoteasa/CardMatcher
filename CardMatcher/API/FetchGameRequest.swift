//
//  FetchGameRequest.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 03.08.2024.
//

import Foundation
import PISAPI

struct FetchGameRequest: APIRequest {
    typealias Response = [Game]

    let httpMethod = HTTPMethod.get

    var params: [String : Any]?
    
    var path: String {
        "themes.json?alt=media&token=6898245a-0586-4fed-b30e-5078faeba078"
    }
}
