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
            VStack(alignment: .leading) {
                Text("Game Log")
                    .font(.headline)
                    .padding(.horizontal)
                
                List(game.gameLog, id: \.self) { log in
                    Text(log)
                        .font(.system(.body, design: .monospaced))
                }
            }
            .frame(maxHeight: .infinity)
        }
        .onAppear {
            game.start()
        }
    }
}

struct MapView: View {
    @ObservedObject var game: Game
    let visibleSize = 7 // 7x7 visible area
    let cellSize: CGFloat = 40
    
    private var visibleRange: (xRange: Range<Int>, yRange: Range<Int>) {
        let halfSize = visibleSize / 2
        let centerX = game.character.position.x
        let centerY = game.character.position.y
        
        let minX = max(0, centerX - halfSize)
        let maxX = min(game.map.size, centerX + halfSize + 1)
        let minY = max(0, centerY - halfSize)
        let maxY = min(game.map.size, centerY + halfSize + 1)
        
        return (minX..<maxX, minY..<maxY)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ZStack {
                    ScrollView([.horizontal, .vertical], showsIndicators: true) {
                        ZStack {
                            // Debug grid lines
                            VStack(spacing: 0) {
                                ForEach(visibleRange.yRange, id: \.self) { y in
                                    HStack(spacing: 0) {
                                        ForEach(visibleRange.xRange, id: \.self) { x in
                                            Rectangle()
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                .frame(width: cellSize, height: cellSize)
                                        }
                                    }
                                }
                            }
                            
                            // Main grid with cells
                            LazyVGrid(columns: Array(repeating: GridItem(.fixed(cellSize), spacing: 0), count: visibleSize), spacing: 0) {
                                ForEach(visibleRange.yRange, id: \.self) { y in
                                    ForEach(visibleRange.xRange, id: \.self) { x in
                                        if let cell = game.map.cell(at: Position(x: x, y: y)) {
                                            CellView(
                                                cell: cell,
                                                x: x,
                                                y: y,
                                                isPlayerCell: x == game.character.position.x && y == game.character.position.y
                                            )
                                            .frame(width: cellSize, height: cellSize)
                                            .id("\(x),\(y)")
                                        }
                                    }
                                }
                            }
                            
                            // Player overlay
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                )
                                .position(
                                    x: CGFloat(game.character.position.x - visibleRange.xRange.lowerBound) * cellSize + cellSize/2,
                                    y: CGFloat(game.character.position.y - visibleRange.yRange.lowerBound) * cellSize + cellSize/2
                                )
                                .zIndex(2)
                        }
                        .frame(width: CGFloat(visibleSize) * cellSize, height: CGFloat(visibleSize) * cellSize)
                    }
                }
                .onChange(of: game.character.position) { newPosition in
                    print("DEBUG: Character moved to position: (\(newPosition.x), \(newPosition.y))")
                    withAnimation(.easeInOut(duration: 0.3)) {
                        // Center on the player's position
                        scrollProxy.scrollTo("\(newPosition.x),\(newPosition.y)", anchor: .center)
                    }
                }
            }
        }
    }
}

struct CellView: View {
    let cell: Cell
    let x: Int
    let y: Int
    let isPlayerCell: Bool
    
    var body: some View {
        ZStack {
            // Base cell background
            Rectangle()
                .fill(cell.type == .empty ? Color.gray.opacity(0.1) : Color.green.opacity(0.2))
            
            // Resource icon if present
            if cell.type == .resource {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.green)
            }
            
            // Coordinates text
            Text("(\(x),\(y))")
                .font(.system(size: 8))
                .foregroundColor(.gray)
                .position(x: 10, y: 10)
        }
    }
}
