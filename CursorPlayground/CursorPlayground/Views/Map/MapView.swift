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
                    ZStack(alignment: .topLeading) {
                        Color.black.opacity(0.1) // Background color for spacing visibility
                        
                        // Main grid
                        let columns = Array(repeating: GridItem(.fixed(viewModel.cellSize), spacing: viewModel.cellSpacing), count: viewModel.visibleRange.xRange.count)
                        
                        LazyVGrid(columns: columns, spacing: viewModel.cellSpacing) {
                            ForEach(viewModel.visibleRange.yRange, id: \.self) { y in
                                ForEach(viewModel.visibleRange.xRange, id: \.self) { x in
                                    if let cell = viewModel.game.map.cell(at: Position(x: x, y: y)) {
                                        CellView(
                                            cell: cell,
                                            x: x,
                                            y: y,
                                            isPlayerCell: x == game.character.position.x && y == game.character.position.y
                                        )
                                        .id("\(x),\(y)")
                                    }
                                }
                            }
                        }
                        .padding(viewModel.cellSpacing)
                        
                        // Player overlay
                        PlayerOverlayView(position: viewModel.getPlayerPosition())
                    }
                    .frame(
                        width: CGFloat(viewModel.visibleRange.xRange.count) * (viewModel.cellSize + viewModel.cellSpacing) + viewModel.cellSpacing,
                        height: CGFloat(viewModel.visibleRange.yRange.count) * (viewModel.cellSize + viewModel.cellSpacing) + viewModel.cellSpacing
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
} 