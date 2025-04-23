import Foundation

class CollectAction: CharacterAction {
    private let map: Map
    
    init(map: Map) {
        self.map = map
    }
    
    func execute(character: Character) -> ActionResult {
        if let currentCell = map.cell(at: character.position), currentCell.type == .resource {
            map.updateCell(at: character.position, type: .empty)
            
            return .collect()
        }
        return .empty()
    }
} 