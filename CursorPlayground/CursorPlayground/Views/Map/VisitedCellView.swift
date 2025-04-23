import SwiftUI

struct VisitedCellView: View {
    let cell: Cell
    private let mainIconSize: CGFloat = 24
    private let secondaryIconSize: CGFloat = 16
    
    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .fill(Color(hex: "F5F5F5"))
                .frame(width: 60, height: 60)
            
            // Top-leading icon (secondary)
            Image(systemName: "star.fill")
                .foregroundColor(cell.rarity.color)
                .font(.system(size: secondaryIconSize))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.leading, 4)
                .padding(.top, 4)
                .opacity(0)
            
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
    }
} 