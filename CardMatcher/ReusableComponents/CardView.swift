//
//  CardView.swift
//  CardMatcher
//
//  Created by Silviu Preoteasa on 31.07.2024.
//

import SwiftUI

struct CardView: View {
    var body: some View {
        GeometryReader { proxy in
            Color.green
                .clipShape(.rect(cornerRadius: 24))
                .frame(width: proxy.size.width / 3)
                .frame(height: proxy.size.height / 4)
        }
    }
}

#Preview {
    ScrollView {
        VStack {
//            ForEach(1..<10) { _ in
                HStack {
//                    GridRow {
                        CardView()
                        CardView()
                        CardView()
//                    }
                }
            HStack {
//                    GridRow {
                    CardView()
                    CardView()
                    CardView()
//                    }
            }
            HStack {
//                    GridRow {
                    CardView()
                    CardView()
                    CardView()
//                    }
            }
//            }
        }
        .frame(maxHeight: .infinity)
    }
}
