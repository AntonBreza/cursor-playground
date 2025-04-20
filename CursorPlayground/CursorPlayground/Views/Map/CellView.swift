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
            cellBackground
            resourceIcon
            coordinatesLabel
        }
    }
    
    // MARK: - View Components
    
    /// Background for the cell
    private var cellBackground: some View {
        Rectangle()
            .fill(cell.type == .empty ? Color.gray.opacity(0.1) : Color.green.opacity(0.2))
    }
    
    /// Resource icon if the cell contains a resource
    @ViewBuilder
    private var resourceIcon: some View {
        if cell.type == .resource {
            Image(systemName: "leaf.fill")
                .foregroundColor(.green)
        }
    }
    
    /// Coordinates label showing the cell's position
    private var coordinatesLabel: some View {
        Text("(\(x),\(y))")
            .font(.system(size: 8))
            .foregroundColor(.gray)
            .position(x: 10, y: 10)
    }
} 