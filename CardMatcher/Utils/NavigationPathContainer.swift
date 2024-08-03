//
//  NavigationPathContainer.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 03.08.2024.
//

import SwiftUI

final class NavigationPathContainer: ObservableObject {
    @Published var path = NavigationPath()
    
    var canNavigateBack: Bool {
        !path.isEmpty
    }
    
    func removeLast() {
        path.removeLast()
    }
    
    func emptyPath() {
        path.removeLast(path.count)
    }
}
