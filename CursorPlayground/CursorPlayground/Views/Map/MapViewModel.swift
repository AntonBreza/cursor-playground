import SwiftUI

class MapViewModel: ObservableObject {
    @ObservedObject var game: Game
    let cellSize: CGFloat = 40
    
    init(game: Game) {
        self.game = game
    }
    
    var visibleRange: (xRange: Range<Int>, yRange: Range<Int>) {
        let centerX = game.character.position.x
        let centerY = game.character.position.y
        
        // Calculate the number of cells that can fit in the screen width
        let screenWidth = UIScreen.main.bounds.width
        let cellsInWidth = Int(screenWidth / cellSize)
        let halfWidth = cellsInWidth / 2
        
        let minX = max(0, centerX - halfWidth)
        let maxX = min(game.map.size, centerX + halfWidth + 1)
        let minY = max(0, centerY - halfWidth)
        let maxY = min(game.map.size, centerY + halfWidth + 1)
        
        return (minX..<maxX, minY..<maxY)
    }
    
    func getPlayerPosition() -> (x: CGFloat, y: CGFloat) {
        let x = CGFloat(game.character.position.x - visibleRange.xRange.lowerBound) * cellSize + cellSize/2
        let y = CGFloat(game.character.position.y - visibleRange.yRange.lowerBound) * cellSize + cellSize/2
        return (x, y)
    }
} 