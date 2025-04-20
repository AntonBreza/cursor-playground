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
            // Top half - Map View with Restart Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        game.restart()
                    }) {
                        Label("Restart", systemImage: "arrow.clockwise")
                            .padding(8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                
                MapView(game: game)
                    .frame(maxHeight: .infinity)
            }
            
            // Bottom half - Game Log
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
