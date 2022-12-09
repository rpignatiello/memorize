//
//  MemoryGame.swift
//  Memorize
//
//  Created by Richard Pignatiello on 12/7/22.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score: Int = 0
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        //add numberOfPairsOfCards * 2 to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
        score = 0 // Reset score when creating new game
    }
    
    mutating func choose(_ card: Card) -> Int {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }), // finding first index of card
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard { // if one card is already face up
                if cards[chosenIndex].content == cards[indexOfTheOneAndOnlyFaceUpCard!].content { // if the second card matches the first card
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 1
                } else if cards[chosenIndex].seenBefore || cards[indexOfTheOneAndOnlyFaceUpCard!].seenBefore{ // if either card has been seen before there is a point penalty
                    if cards[chosenIndex].seenBefore { score -= 1 }
                    if cards[indexOfTheOneAndOnlyFaceUpCard!].seenBefore { score -= 1 }
                }
                cards[chosenIndex].seenBefore = true
                cards[indexOfTheOneAndOnlyFaceUpCard!].seenBefore = true
                indexOfTheOneAndOnlyFaceUpCard = nil // 0 cards are selected now
            } else {
                for index in 0..<cards.count {
                    cards[index].isFaceUp = false // flip all cards face down
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle() // flip chosen card face up, the only face up card
        }
        return score
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var seenBefore: Bool = false
        var content: CardContent
        var id: Int
    }
}
