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
        HStack {
            // Game Map
            VStack {
                Text("Energy: \(game.character.energy)")
                    .font(.headline)
                Text("Resources: \(game.character.resourcesCollected)")
                    .font(.headline)
                
                MapView(game: game)
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
            }
            
            // Game Log
            VStack {
                Text("Game Log")
                    .font(.headline)
                List(game.gameLog, id: \.self) { log in
                    Text(log)
                        .font(.system(.body, design: .monospaced))
                }
            }
            .frame(width: 300)
        }
        .padding()
        .onAppear {
            game.start()
        }
    }
}

struct MapView: View {
    @ObservedObject var game: Game
    let cellSize: CGFloat = 8
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw map cells
                ForEach(0..<game.map.size, id: \.self) { y in
                    ForEach(0..<game.map.size, id: \.self) { x in
                        if let cell = game.map.cell(at: Position(x: x, y: y)) {
                            CellView(cell: cell, size: cellSize)
                                .position(
                                    x: CGFloat(x) * cellSize + cellSize/2,
                                    y: CGFloat(y) * cellSize + cellSize/2
                                )
                        }
                    }
                }
                
                // Draw character
                Circle()
                    .fill(Color.blue)
                    .frame(width: cellSize, height: cellSize)
                    .position(
                        x: CGFloat(game.character.position.x) * cellSize + cellSize/2,
                        y: CGFloat(game.character.position.y) * cellSize + cellSize/2
                    )
            }
        }
    }
}

struct CellView: View {
    let cell: Cell
    let size: CGFloat
    
    var body: some View {
        Group {
            switch cell.type {
            case .empty:
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            case .resource:
                Image(systemName: "leaf.fill")
                    .foregroundColor(.green)
            }
        }
        .frame(width: size, height: size)
    }
}
