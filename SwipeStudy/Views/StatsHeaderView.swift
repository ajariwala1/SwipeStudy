//
// StatsHeaderView.swift : SwipeStudy
//
// Copyright © 2026 Auburn University.
// All Rights Reserved.

import SwiftUI

struct StatsHeaderView: View {
    let currentIndex: Int
    let totalCards: Int
    let gotItCount: Int
    let reviewCount: Int
    let favoriteCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("SwipeStudy")
                .font(.system(size: 38, weight: .black))
                .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.23))

            Text("Card \(currentIndex + 1) of \(totalCards)")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color(red: 0.44, green: 0.42, blue: 0.49))

            HStack(spacing: 10) {
                StatBoxView(
                    label: "Got it",
                    value: gotItCount
                )

                StatBoxView(
                    label: "Review",
                    value: reviewCount
                )

                StatBoxView(
                    label: "Favorites",
                    value: favoriteCount
                )
            }
        }
    }
}

struct StatBoxView: View {
    let label: String
    let value: Int

    var body: some View {
        VStack(spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 11, weight: .heavy))
                .tracking(0.5)
                .foregroundStyle(Color(red: 0.79, green: 0.77, blue: 0.91))

            Text("\(value)")
                .font(.system(size: 24, weight: .black))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(red: 0.18, green: 0.18, blue: 0.23))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    StatsHeaderView(currentIndex: 0, totalCards: 10, gotItCount: 0, reviewCount: 0, favoriteCount: 0)
}
