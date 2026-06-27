//
// Flashcard.swift : SwipeStudy
//
// Copyright © 2026 Auburn University.
// All Rights Reserved.


import Foundation

struct Flashcard: Identifiable {
    let id: Int
    let question: String
    let answer: String
    var isFavorite: Bool = false
}
