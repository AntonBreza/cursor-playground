import Foundation
import SwiftUI

class Map {
    private(set) var cells: [[Cell]]
    let size: Int
    
    init(size: Int) {
        self.size = size
        self.cells = Array(repeating: Array(repeating: Cell(position: Position(x: 0, y: 0)), count: size), count: size)
        for y in 0..<size {
            for x in 0..<size {
                cells[y][x] = Cell(position: Position(x: x, y: y))
            }
        }
    }
    
    func cell(at position: Position) -> Cell? {
        guard position.x >= 0 && position.x < size && position.y >= 0 && position.y < size else {
            return nil
        }
        return cells[position.y][position.x]
    }
    
    func updateCell(at position: Position, type: CellType) {
        guard position.x >= 0 && position.x < size && position.y >= 0 && position.y < size else {
            return
        }
        let isVisited = cells[position.y][position.x].isVisited
        cells[position.y][position.x] = Cell(
            position: position,
            type: type,
            isVisited: isVisited
        )
    }
    
    func markCellAsVisited(at position: Position) {
        guard position.x >= 0 && position.x < size && position.y >= 0 && position.y < size else {
            return
        }
        var cell = cells[position.y][position.x]
        cell.isVisited = true
        cells[position.y][position.x] = cell
    }
    
    func getCellsInRange(center: Position, range: Int) -> [Cell] {
        var result: [Cell] = []
        for y in (center.y - range)...(center.y + range) {
            for x in (center.x - range)...(center.x + range) {
                if let cell = cell(at: Position(x: x, y: y)) {
                    if cell.position.distance(to: center) <= range {
                        result.append(cell)
                    }
                }
            }
        }
        return result
    }
} 