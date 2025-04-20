import SwiftUI

struct CharacterScreen: View {
    @ObservedObject var game: Game
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Position") {
                    LabeledContent("X", value: "\(game.character.position.x)")
                    LabeledContent("Y", value: "\(game.character.position.y)")
                }
                
                Section("Stats") {
                    LabeledContent("Energy", value: "\(game.character.energy)")
                    LabeledContent("Resources Collected", value: "\(game.character.resourcesCollected)")
                }
                
                Section("Vision") {
                    LabeledContent("Range", value: "2")
                }
            }
            .navigationTitle("Character")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 