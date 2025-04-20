//
//  ContentView.swift
//  CursorPlayground
//
//  Created by Anton Breza on 08.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var game = Game()
    @State private var showingCharacterScreen = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Map View
                MapView(game: game)
                    .padding(0)
                    .safeAreaInset(edge: .top) { Color.clear }
                
                // Character Status View
                CharacterStatusView(game: game, onCharacterTap: {
                    showingCharacterScreen = true
                })
                
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
                        .padding(.bottom, 16)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .safeAreaInset(edge: .bottom) { Color.clear }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        game.restart()
                    }) {
                        Label("Restart", systemImage: "arrow.clockwise")
                    }
                }
            }
            .sheet(isPresented: $showingCharacterScreen) {
                CharacterScreen(game: game)
            }
        }
        .onAppear {
            game.start()
        }
    }
}
