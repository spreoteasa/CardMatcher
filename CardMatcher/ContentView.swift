//
//  ContentView.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        MainCoordinatorView()
            .environment(\.managedObjectContext, managedObjectContext)
    }
}

#Preview {
    ContentView()
}
