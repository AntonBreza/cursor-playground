import Foundation
import SwiftUI

enum CellType {
    case empty
    case resource
}

struct Cell: Identifiable {
    let id = UUID()
    let position: Position
    var type: CellType
    let rarity: CellRarity
    let backgroundColor: Color
    
    init(position: Position, type: CellType = .empty, rarity: CellRarity? = nil, backgroundColor: Color = .clear) {
        self.position = position
        self.type = type
        self.rarity = rarity ?? CellRarity.allCases.randomElement()!
        self.backgroundColor = backgroundColor
    }
}

struct Position: Equatable {
    let x: Int
    let y: Int
    
    func distance(to other: Position) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
} 