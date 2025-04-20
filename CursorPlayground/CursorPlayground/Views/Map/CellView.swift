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
                .frame(width: 60, height: 60)
            
            // Top-leading icon (secondary)
            Image(systemName: "star.fill")
                .foregroundColor(cell.rarity.color)
                .font(.system(size: secondaryIconSize))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 4)
                .padding(.top, 4)
            
            // Bottom-trailing icon (main)
            if cell.type == .resource {
                Image(systemName: "leaf.fill")
                    .foregroundColor(cell.rarity.color)
                    .font(.system(size: mainIconSize))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.trailing, 4)
                    .padding(.bottom, 4)
            }
        }
        .frame(width: 60, height: 60)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(cell.rarity.color, lineWidth: cell.rarity.borderWidth / 2)
        )
    }
} 