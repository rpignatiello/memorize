//
//  ContentView.swift
//  Memorize
//
//  Created by Richard Pignatiello on 12/7/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            // New Game Button
            Button(action: {
                viewModel.createMemoryGame()
            }, label: {
                Text("New Game")
            })
            // Theme Name + Score
            HStack {
                Text(viewModel.themeName)
                Spacer()
                Text("\(viewModel.score)")
            }
            .padding(.horizontal)
            .font(.title)
            // View of All Cards for Active Game
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card).aspectRatio(2/3, contentMode:.fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
                .padding(.horizontal)
                .foregroundColor(viewModel.color)
            }
            Spacer()
            HStack {
                Spacer()
            }
            .font(.title2)
            .padding(.horizontal)
        }
    }
    
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                shape
                    .fill()
                    .foregroundColor(.white)
                shape
                    .strokeBorder(lineWidth: 3)
                Text(card.content)
                    .font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0) // Hides the card by making it invisible
            }
            else {
                shape
                    .fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
        ContentView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
