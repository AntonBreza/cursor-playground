import SwiftUI

/// A view that represents a single cell in the game map.
/// Can display empty cells, resource cells, and coordinates.
struct CellView: View {
    // MARK: - Properties
    
    let cell: Cell
    let x: Int
    let y: Int
    let isPlayerCell: Bool
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if !cell.isVisited {
                UnvisitedCellView(cell: cell)
            } else {
                VisitedCellView(cell: cell)
            }
        }
        .frame(width: 60, height: 60)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(cell.isVisited ? cell.rarity.color : Color.gray.opacity(0.3), lineWidth: 1.5)
        )
        .rotation3DEffect(
            .degrees(cell.isVisited ? 0 : 180),
            axis: (x: 0.0, y: 1.0, z: 0.0),
            anchor: .center,
            perspective: 0.5
        )
        .animation(.easeInOut(duration: 0.5), value: cell.isVisited)
    }
}
