import SwiftUI

/// A view that represents a single cell in the game map.
/// Can display empty cells, resource cells, and coordinates.
struct CellView: View {
    // MARK: - Properties
    
    let cell: Cell
    let x: Int
    let y: Int
    let isPlayerCell: Bool
    
    private let mainIconSize: CGFloat = 24
    private let secondaryIconSize: CGFloat = 16
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .fill(cell.backgroundColor)
                .frame(width: 50, height: 50)
            
            // Top-leading icon
            Image(systemName: "star.fill")
                .foregroundColor(cell.rarity.color)
                .font(.system(size: secondaryIconSize))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 4)
                .padding(.top, 4)
            
            // Center icon (larger)
            if cell.type == .resource {
                Image(systemName: "leaf.fill")
                    .foregroundColor(cell.rarity.color)
                    .font(.system(size: mainIconSize))
            }
            
            // Coordinates label
            Text("(\(x),\(y))")
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .position(x: 12, y: 12)
        }
        .frame(width: 50, height: 50)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(cell.rarity.color, lineWidth: cell.rarity.borderWidth)
        )
    }
} 