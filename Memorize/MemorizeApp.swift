//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Richard Pignatiello on 12/7/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
