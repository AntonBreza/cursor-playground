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
                .frame(maxHeight: .infinity)
            
            // Restart Button
            Button(action: {
                game.restart()
            }) {
                Label("Restart", systemImage: "arrow.clockwise")
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.vertical, 8)
            
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
                }
                .frame(maxHeight: 200)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
        }
        .onAppear {
            game.start()
        }
    }
}
