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
            .background(
                Rectangle()
                    .fill(Color.orange.opacity(0.05))
                    .shadow(color: .orange.opacity(0.05), radius: 2, x: 0, y: 0)
                    .padding(4)
            )
    }
} 
