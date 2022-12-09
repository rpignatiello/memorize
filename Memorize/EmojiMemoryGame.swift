//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Richard Pignatiello on 12/7/22.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    var color: Color
    var themeName: String
    var score: Int
    
    init() {
        score = 0
        let theme = EmojiGameTheme.themes.randomElement()!
        model = MemoryGame(numberOfPairsOfCards: theme.numberOfPairs, createCardContent: { pairIndex in
            theme.emojis[pairIndex]
        })
        color = theme.color
        themeName = theme.name
    }
    
    /// Creates a new memory game , discarding data from the old one
    func createMemoryGame() {
        let theme = EmojiGameTheme.themes.randomElement()
        let emojis = theme!.emojis.shuffled()
        model = MemoryGame(numberOfPairsOfCards: theme!.numberOfPairs) { emojis[$0] }
        score = model.score
        color = theme?.color ?? Color.red
        themeName = theme!.name
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        score = model.choose(card)
    }
}

struct EmojiGameTheme {
    let name: String
    let emojis: [String]
    let numberOfPairs: Int
    let color: Color
    
    static var themes = [
        EmojiGameTheme(name: "Animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁"], numberOfPairs: 8, color: Color.red),
        EmojiGameTheme(name: "Vehicles", emojis: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚"], numberOfPairs: 8, color: Color.blue)
    ]
}
