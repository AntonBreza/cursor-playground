import SwiftUI

struct UnvisitedCellView: View {
    let cell: Cell
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 60, height: 60)
            .overlay(
                Image(systemName: "map")
                    .foregroundColor(.gray)
                    .font(.system(size: 24))
            )
            .shadow(radius: 2)
    }
} 