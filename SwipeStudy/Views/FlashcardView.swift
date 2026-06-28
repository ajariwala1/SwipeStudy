//
// FlashcardView.swift : SwipeStudy
//
// Copyright © 2026 Auburn University.
// All Rights Reserved.

import SwiftUI

struct FlashcardView: View {
    let card: Flashcard
    let onSwipeRight: () -> Void
    let onSwipeLeft: () -> Void
    let onFavorite: () -> Void

    @State var cardOffset: CGSize = .zero
    @State var isAnimatingOut = false
    @State var isAnswerShowing = false

    let swipeThreshold: CGFloat = 120

    var body: some View {
        ZStack {
            cardBody
        }
        .offset(cardOffset)
        .rotationEffect(.degrees(Double(cardOffset.width / 18)))
        .gesture(
            DragGesture()
                .onChanged { value in
                    if isAnimatingOut {
                        return
                    }

                    cardOffset = value.translation
                }
                .onEnded { _ in
                    if isAnimatingOut {
                        return
                    }

                    if cardOffset.width > swipeThreshold {
                        animateCardOut(isKnown: true)
                    } else if cardOffset.width < -swipeThreshold {
                        animateCardOut(isKnown: false)
                    } else {
                        snapCardBack()
                    }
                }
        )
        .onTapGesture {
            if isAnimatingOut {
                return
            }

            withAnimation(.easeInOut(duration: 0.35)) {
                isAnswerShowing.toggle()
            }
        }
        .onLongPressGesture {
            if isAnimatingOut {
                return
            }

            onFavorite()
        }
        .animation(.easeOut(duration: 0.22), value: cardOffset)
    }

    var cardBody: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(isAnswerShowing ? .black : .white)
                .shadow(
                    color: .black,
                    radius: 5,
                    x: 0,
                    y: 2
                )

            VStack(spacing: 18) {
                Text(isAnswerShowing ? "ANSWER" : "QUESTION")
                    .font(.system(size: 13, weight: .black))
                    .tracking(1.2)
                    .foregroundStyle(
                        isAnswerShowing
                        ? .white
                        : .black
                    )

                Text(isAnswerShowing ? card.answer : card.question)
                    .font(.system(size: 30, weight: .black))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        isAnswerShowing
                        ? .white
                        : .black
                    )
                    .lineSpacing(4)
            }
            .padding(28)

            if card.isFavorite {
                VStack {
                    HStack {
                        Spacer()

                        Image(systemName: "star.fill")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(Color.orange)
                    }

                    Spacer()
                }
                .padding(24)
            }

            if cardOffset.width > 30 {
                VStack {
                    HStack {
                        SwipeLabelView(
                            text: "GOT IT",
                            color: .green,
                            angle: -12
                        )

                        Spacer()
                    }

                    Spacer()
                }
                .padding(24)
            }

            if cardOffset.width < -30 {
                VStack {
                    HStack {
                        Spacer()

                        SwipeLabelView(
                            text: "REVIEW",
                            color: .red,
                            angle: 12
                        )
                    }

                    Spacer()
                }
                .padding(24)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 360)
        .rotation3DEffect(
            .degrees(isAnswerShowing ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .scaleEffect(x: isAnswerShowing ? -1 : 1, y: 1)
    }

    func snapCardBack() {
        withAnimation(.easeOut(duration: 0.22)) {
            cardOffset = .zero
        }
    }

    func animateCardOut(isKnown: Bool) {
        isAnimatingOut = true

        withAnimation(.easeOut(duration: 0.22)) {
            cardOffset = CGSize(
                width: isKnown ? 600 : -600,
                height: cardOffset.height
            )
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            if isKnown {
                onSwipeRight()
            } else {
                onSwipeLeft()
            }

            cardOffset = .zero
            isAnswerShowing = false
            isAnimatingOut = false
        }
    }
}

struct SwipeLabelView: View {
    let text: String
    let color: Color
    let angle: Double

    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .bold))
            .tracking(1)
            .foregroundStyle(color)
            .padding(.horizontal, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color, lineWidth: 4)
            )
            .rotationEffect(.degrees(angle))
    }
}

#Preview {
    FlashcardView(card: Flashcard(id: 1, question: "What language is commonly used with SwiftUI?", answer: "Swift"), onSwipeRight: {}, onSwipeLeft: {}, onFavorite: {})
}
