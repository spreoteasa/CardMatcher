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
            ScrollView {
                VStack {
                    ForEach(scores) { score in
                        HStack {
                            Image(systemName: "moonphase.waxing.crescent")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .foregroundStyle(.black)
                                .brightness(1)
                            Text("Points achieved -> \(score.points)")
                            Text("in \(score.time) seconds")
                        }
                        .padding()
                        .background(.yellow, in: .rect(cornerRadius: 24))
                    }
                }
                .frame(maxWidth: .infinity)
            }
            
        }
        .frame(maxWidth: .infinity)
        
        .background(.mint)
    }
}

#Preview {
    LeaderboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
