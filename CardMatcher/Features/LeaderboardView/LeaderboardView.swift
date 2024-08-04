//
//  LeaderboardView.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 04.08.2024.
//

import SwiftUI

struct LeaderboardView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\.points, order: .reverse)]
    ) var scores: FetchedResults<Score>
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.black)
            scoresSection
            
        }
        .frame(maxWidth: .infinity)
        .background(.mint)
    }
}

//MARK: - View Components
extension LeaderboardView {
    var scoresSection: some View {
        ScrollView {
            VStack {
                ForEach(scores) { score in
                    HStack {
                        if let game = score.game {
                            Text("For game \(game) score \(score.points)")
                                .font(.title2)
                                .foregroundStyle(.black)
                        }
                    }
                    .padding()
                    .background(.yellow, in: .rect(cornerRadius: 24))
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    LeaderboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
