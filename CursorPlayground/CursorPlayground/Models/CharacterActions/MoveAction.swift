import Foundation

class MoveAction: CharacterAction {
    private let map: Map
    
    init(map: Map) {
        self.map = map
    }
    
    func execute(character: Character) -> ActionResult {
        guard canMove(character: character) else {
            return .empty()
        }
        let moveResult = executeMove(character: character)
        map.markCellAsVisited(at: character.position)
        return moveResult
    }
    
    private func canMove(character: Character) -> Bool {
        guard map.cell(at: character.position) != nil else {
            return false
        }
        return character.energy - GameConstants.Movement.energyCost >= 0
    }
    
    private func executeMove(character: Character) -> ActionResult {
        character.updateEnergy(-GameConstants.Movement.energyCost)
        return ActionResult(changes: [
            .init(type: .position, value: GameConstants.Movement.positionChange),
            .init(type: .energy, value: -GameConstants.Movement.energyCost)
        ])
    }
} 
