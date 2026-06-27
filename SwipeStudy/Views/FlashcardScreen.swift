//
// FlashcardScreen.swift : SwipeStudy
//
// Copyright © 2026 Auburn University.
// All Rights Reserved.

import SwiftUI

struct FlashcardScreen: View {
    @State var flashcards = sampleFlashcards
    @State var currentIndex = 0
    @State var gotItCount = 0
    @State var reviewCount = 0
    @State var favoriteCount = 0
    @State var isComplete = false

    var currentCard: Flashcard {
        flashcards[currentIndex]
    }

    var isLastCard: Bool {
        currentIndex == flashcards.count - 1
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 20) {
                StatsHeaderView(
                    currentIndex: currentIndex,
                    totalCards: flashcards.count,
                    gotItCount: gotItCount,
                    reviewCount: reviewCount,
                    favoriteCount: favoriteCount
                )

                Text("Tap to flip and see the answer. Swipe right for Got it. Swipe left for Review. Long press to favorite")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    
                if isComplete {
                    CompletionPanelView(
                        gotItCount: gotItCount,
                        reviewCount: reviewCount,
                        favoriteCount: favoriteCount,
                        onRestart: restartSession
                    )
                    .transition(.scale.combined(with: .opacity))
                } else {
                    FlashcardView(
                        card: currentCard,
                        onSwipeRight: markGotIt,
                        onSwipeLeft: markReview,
                        onFavorite: toggleFavorite
                    )
                    .id(currentCard.id)
                    .transition(.scale.combined(with: .opacity))
                }

                Button {
                    restartSession()
                } label: {
                    Text("Reset Session")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
            }
            .padding(18)
        }
        .animation(.easeOut(duration: 0.22), value: isComplete)
        .animation(.easeOut(duration: 0.22), value: currentIndex)
    }

    func goToNextCard() {
        if isLastCard {
            isComplete = true
            return
        }

        currentIndex += 1
    }

    func restartSession() {
        currentIndex = 0
        gotItCount = 0
        reviewCount = 0
        favoriteCount = 0
        isComplete = false

        for index in flashcards.indices {
            flashcards[index].isFavorite = false
        }
    }

    func markGotIt() {
        gotItCount += 1
        goToNextCard()
    }

    func markReview() {
        reviewCount += 1
        goToNextCard()
    }

    func toggleFavorite() {
        flashcards[currentIndex].isFavorite.toggle()

        if flashcards[currentIndex].isFavorite {
            favoriteCount += 1
        } else {
            favoriteCount -= 1
        }
    }
}

struct CompletionPanelView: View {
    let gotItCount: Int
    let reviewCount: Int
    let favoriteCount: Int
    let onRestart: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Session Complete")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.center)

            Text("Got it: \(gotItCount)\nReview: \(reviewCount)\nFavorites: \(favoriteCount)")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.gray)
                .multilineTextAlignment(.center)

            Button {
                onRestart()
            } label: {
                Text("Restart")
                    .padding(20)
                    .font(.system(size: 20, weight: .bold))
                
            }
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}


#Preview {
    FlashcardScreen()
}
