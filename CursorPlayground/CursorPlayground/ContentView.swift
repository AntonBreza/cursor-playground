//
//  ContentView.swift
//  CursorPlayground
//
//  Created by Anton Breza on 08.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var game = Game()
    
    var body: some View {
        VStack(spacing: 0) {
            // Map View
            MapView(game: game)
                .border(Color.red, width: 1)
                .safeAreaInset(edge: .top) { Color.clear }
            
            // Character Status View
            CharacterStatusView(game: game)
                .border(Color.blue, width: 1)
            
            // Game Log
            VStack(alignment: .leading, spacing: 8) {
                Text("Game Log")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(game.gameLog.reversed()) { log in
                            LogMessageView(entry: log)
                        }
                    }
                    .padding(.bottom, 16) // Add some padding at the bottom for better scrolling
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .border(Color.green, width: 1)
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            game.start()
        }
    }
}
