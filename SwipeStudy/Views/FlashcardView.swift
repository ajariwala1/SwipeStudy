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
                .fill(isAnswerShowing ? Color(red: 0.25, green: 0.24, blue: 0.34) : .white)
                .shadow(
                    color: Color.black.opacity(0.13),
                    radius: 24,
                    x: 0,
                    y: 12
                )

            VStack(spacing: 18) {
                Text(isAnswerShowing ? "ANSWER" : "QUESTION")
                    .font(.system(size: 13, weight: .black))
                    .tracking(1.2)
                    .foregroundStyle(
                        isAnswerShowing
                        ? Color(red: 0.79, green: 0.77, blue: 0.91)
                        : Color(red: 0.44, green: 0.42, blue: 0.49)
                    )

                Text(isAnswerShowing ? card.answer : card.question)
                    .font(.system(size: 30, weight: .black))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(
                        isAnswerShowing
                        ? .white
                        : Color(red: 0.18, green: 0.18, blue: 0.23)
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
                            .foregroundStyle(Color(red: 1.0, green: 0.7, blue: 0.0))
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
                            color: Color(red: 0.18, green: 0.68, blue: 0.4),
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
                            color: Color(red: 0.91, green: 0.36, blue: 0.46),
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
