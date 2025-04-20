import SwiftUI

struct CharacterStatusView: View {
    @ObservedObject var game: Game
    
    var body: some View {
        HStack(spacing: 16) {
            // Energy Bar
            VStack(alignment: .leading, spacing: 4) {
                Text("Energy")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                        
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: geometry.size.width * CGFloat(game.character.energy) / 1000.0)
                            .cornerRadius(4)
                    }
                }
                .frame(height: 8)
                
                Text("\(game.character.energy)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Resource Counter
            VStack(alignment: .leading, spacing: 4) {
                Text("Resources")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "leaf.fill")
                        .foregroundColor(.green)
                    Text("\(game.character.resourcesCollected)")
                        .font(.headline)
                }
            }
            
            Spacer()
            
            // Restart Button
            Button(action: {
                game.restart()
            }) {
                Label("Restart", systemImage: "arrow.clockwise")
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
} 