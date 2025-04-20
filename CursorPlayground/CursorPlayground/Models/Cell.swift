import Foundation

enum CellType {
    case empty
    case resource
}

struct Cell: Identifiable {
    let id = UUID()
    let position: Position
    var type: CellType
    
    init(position: Position, type: CellType = .empty) {
        self.position = position
        self.type = type
    }
}

struct Position: Equatable {
    let x: Int
    let y: Int
    
    func distance(to other: Position) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
} 