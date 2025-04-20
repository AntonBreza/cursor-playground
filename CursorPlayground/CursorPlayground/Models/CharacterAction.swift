import Foundation

struct ActionResult {
    struct Change {
        let type: ChangeType
        let value: Int
    }
    
    enum ChangeType {
        case position
        case energy
        case resources
        case health
        // Add more change types as needed
    }
    
    let changes: [Change]
    
    static func empty() -> ActionResult {
        ActionResult(changes: [])
    }
}

protocol CharacterAction {
    func execute(character: Character) -> ActionResult
}

class MoveAction: CharacterAction {
    private let map: Map
    private let visionRange: Int
    
    init(map: Map, visionRange: Int) {
        self.map = map
        self.visionRange = visionRange
    }
    
    func execute(character: Character) -> ActionResult {
        let visibleCells = map.getCellsInRange(center: character.position, range: visionRange)
        let resources = visibleCells.filter { $0.type == .resource }
        
        if resources.isEmpty {
            // No resources in range, move randomly
            return moveRandomly(character: character)
        }
        
        // Find closest resource
        let closestResource = resources.min { a, b in
            a.position.distance(to: character.position) < b.position.distance(to: character.position)
        }!
        
        // Move towards the resource
        let newPosition = moveTowards(character: character, target: closestResource.position)
        character.updatePosition(newPosition)
        
        return ActionResult(changes: [
            .init(type: .position, value: 1),
            .init(type: .energy, value: -5)
        ])
    }
    
    private func moveRandomly(character: Character) -> ActionResult {
        // Define possible moves (up, right, down, left)
        let possibleMoves = [
            (dx: 0, dy: -1), // up
            (dx: 1, dy: 0),  // right
            (dx: 0, dy: 1),  // down
            (dx: -1, dy: 0)  // left
        ]
        
        // Filter valid moves (those that stay within map bounds)
        let validMoves = possibleMoves.filter { move in
            let newX = character.position.x + move.dx
            let newY = character.position.y + move.dy
            return newX >= 0 && newX < map.size && newY >= 0 && newY < map.size
        }
        
        // If we have valid moves, choose one randomly
        if let randomMove = validMoves.randomElement() {
            let newPosition = Position(
                x: character.position.x + randomMove.dx,
                y: character.position.y + randomMove.dy
            )
            character.updatePosition(newPosition)
            
            return ActionResult(changes: [
                .init(type: .position, value: 1),
                .init(type: .energy, value: -5)
            ])
        }
        
        return .empty()
    }
    
    private func moveTowards(character: Character, target: Position) -> Position {
        var newX = character.position.x
        var newY = character.position.y
        
        if target.x > character.position.x {
            newX += 1
        } else if target.x < character.position.x {
            newX -= 1
        }
        
        if target.y > character.position.y {
            newY += 1
        } else if target.y < character.position.y {
            newY -= 1
        }
        
        let newPosition = Position(x: newX, y: newY)
        return map.cell(at: newPosition) != nil ? newPosition : character.position
    }
}

class CollectAction: CharacterAction {
    private let map: Map
    
    init(map: Map) {
        self.map = map
    }
    
    func execute(character: Character) -> ActionResult {
        if let currentCell = map.cell(at: character.position), currentCell.type == .resource {
            map.updateCell(at: character.position, type: .empty)
            
            return ActionResult(changes: [
                .init(type: .resources, value: 1),
                .init(type: .energy, value: -1)
            ])
        }
        return .empty()
    }
} 