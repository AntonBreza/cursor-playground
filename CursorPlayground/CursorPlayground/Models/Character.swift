import Foundation

class Character {
    private(set) var position: Position
    private(set) var energy: Int
    private(set) var resourcesCollected: Int
    private let visionRange: Int
    private let map: Map
    
    init(startPosition: Position, initialEnergy: Int, map: Map, visionRange: Int = 2) {
        self.position = startPosition
        self.energy = initialEnergy
        self.map = map
        self.visionRange = visionRange
        self.resourcesCollected = 0
    }
    
    func move() -> Bool {
        let visibleCells = map.getCellsInRange(center: position, range: visionRange)
        let resources = visibleCells.filter { $0.type == .resource }
        
        if resources.isEmpty {
            // No resources in range, move randomly
            moveRandomly()
            return true
        }
        
        // Find closest resource
        let closestResource = resources.min { a, b in
            a.position.distance(to: position) < b.position.distance(to: position)
        }!
        
        // Move towards the resource
        let newPosition = moveTowards(target: closestResource.position)
        
        // Update position and energy
        position = newPosition
        energy -= 5 // Movement cost
        
        // Collect resource if we're on it
        if let currentCell = map.cell(at: position), currentCell.type == .resource {
            map.updateCell(at: position, type: .empty)
            energy -= 1 // Collection cost
            resourcesCollected += 1
        }
        
        return true
    }
    
    private func moveRandomly() {
        // Define possible moves (up, right, down, left)
        let possibleMoves = [
            (dx: 0, dy: -1), // up
            (dx: 1, dy: 0),  // right
            (dx: 0, dy: 1),  // down
            (dx: -1, dy: 0)  // left
        ]
        
        // Filter valid moves (those that stay within map bounds)
        let validMoves = possibleMoves.filter { move in
            let newX = position.x + move.dx
            let newY = position.y + move.dy
            return newX >= 0 && newX < map.size && newY >= 0 && newY < map.size
        }
        
        // If we have valid moves, choose one randomly
        if let randomMove = validMoves.randomElement() {
            let newPosition = Position(
                x: position.x + randomMove.dx,
                y: position.y + randomMove.dy
            )
            position = newPosition
            energy -= 5 // Movement cost
        }
    }
    
    private func moveTowards(target: Position) -> Position {
        var newX = position.x
        var newY = position.y
        
        if target.x > position.x {
            newX += 1
        } else if target.x < position.x {
            newX -= 1
        }
        
        if target.y > position.y {
            newY += 1
        } else if target.y < position.y {
            newY -= 1
        }
        
        let newPosition = Position(x: newX, y: newY)
        return map.cell(at: newPosition) != nil ? newPosition : position
    }
    
    var isAlive: Bool {
        return energy > 0
    }
} 