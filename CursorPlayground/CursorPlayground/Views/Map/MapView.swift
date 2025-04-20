import SwiftUI

/// A view that displays a scrollable game map with a visible area centered on the player's position.
/// The map shows a grid of cells, with the player's position highlighted and resources visible.
struct MapView: View {
    @ObservedObject var game: Game
    @StateObject private var viewModel: MapViewModel
    
    init(game: Game) {
        self.game = game
        _viewModel = StateObject(wrappedValue: MapViewModel(game: game))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    ZStack(alignment: .center) {
                        GridLinesView(visibleRange: viewModel.visibleRange, cellSize: viewModel.cellSize)
                        mainGrid
                        PlayerOverlayView(position: viewModel.getPlayerPosition())
                    }
                    .frame(
                        width: CGFloat(viewModel.visibleRange.xRange.count) * viewModel.cellSize,
                        height: CGFloat(viewModel.visibleRange.yRange.count) * viewModel.cellSize
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .onChange(of: game.character.position) { newPosition in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        scrollProxy.scrollTo("\(newPosition.x),\(newPosition.y)", anchor: .center)
                    }
                }
            }
        }
        .frame(height: UIScreen.main.bounds.width * 0.7)
        .padding(0)
    }
    
    private var mainGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(viewModel.cellSize), spacing: 0), count: viewModel.visibleRange.xRange.count), spacing: 0) {
            ForEach(viewModel.visibleRange.yRange, id: \.self) { y in
                ForEach(viewModel.visibleRange.xRange, id: \.self) { x in
                    if let cell = viewModel.game.map.cell(at: Position(x: x, y: y)) {
                        CellView(
                            cell: cell,
                            x: x,
                            y: y,
                            isPlayerCell: x == game.character.position.x && y == game.character.position.y
                        )
                        .frame(width: viewModel.cellSize, height: viewModel.cellSize)
                        .id("\(x),\(y)")
                    }
                }
            }
        }
    }
} 