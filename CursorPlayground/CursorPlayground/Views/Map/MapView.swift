import SwiftUI

/// A view that displays a scrollable game map with a visible area centered on the player's position.
/// The map shows a grid of cells, with the player's position highlighted and resources visible.
struct MapView: View {
    // MARK: - Properties
    
    @ObservedObject var game: Game
    let visibleSize = 7 // 7x7 visible area
    let cellSize: CGFloat = 40
    
    // MARK: - Computed Properties
    
    /// Calculates the visible range of cells based on the player's position
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
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ZStack {
                    ScrollView([.horizontal, .vertical], showsIndicators: true) {
                        ZStack {
                            gridLines
                            mainGrid
                            playerOverlay
                        }
                        .frame(width: CGFloat(visibleSize) * cellSize, height: CGFloat(visibleSize) * cellSize)
                    }
                }
                .onChange(of: game.character.position) { newPosition in
                    print("DEBUG: Character moved to position: (\(newPosition.x), \(newPosition.y))")
                    withAnimation(.easeInOut(duration: 0.3)) {
                        scrollProxy.scrollTo("\(newPosition.x),\(newPosition.y)", anchor: .center)
                    }
                }
            }
        }
    }
    
    // MARK: - View Components
    
    /// Grid lines for visual separation of cells
    private var gridLines: some View {
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
    }
    
    /// Main grid containing game cells
    private var mainGrid: some View {
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
    }
    
    /// Player character overlay
    private var playerOverlay: some View {
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
} 