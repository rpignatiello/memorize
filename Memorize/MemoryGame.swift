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
        score = 0
    }
    
    mutating func choose(_ card: Card) -> Int {
        print("\(score)")
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[indexOfTheOneAndOnlyFaceUpCard!].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 1
                } else if cards[chosenIndex].seenBefore {
                    score -= 1
                    if cards[indexOfTheOneAndOnlyFaceUpCard!].seenBefore {
                        score -= 1
                    }
                }
                cards[chosenIndex].seenBefore = true
                cards[indexOfTheOneAndOnlyFaceUpCard!].seenBefore = true
                indexOfTheOneAndOnlyFaceUpCard = nil
            } else {
                for index in 0..<cards.count {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
        print("\(cards)")
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
