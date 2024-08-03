//
//  CoordinatorView.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 03.08.2024.
//

import SwiftUI

protocol CoordinatorView: View {
    associatedtype CoordinatedScreenType
    associatedtype SomeView: View
    
    @ViewBuilder
    func getScreen(_ state: CoordinatedScreenType) -> SomeView
}
