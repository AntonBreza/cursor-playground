import SwiftUI

struct PlayerOverlayView: View {
    let position: (x: CGFloat, y: CGFloat)
    
    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 30, height: 30)
            .overlay(
                Image(systemName: "person.fill")
                    .foregroundColor(.white)
            )
            .position(x: position.x, y: position.y)
            .zIndex(2)
    }
} 