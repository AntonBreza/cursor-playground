import SwiftUI

class MapViewModel: ObservableObject {
    @ObservedObject var game: Game
    let visibleSize = 7
    let cellSize: CGFloat = 40
    
    init(game: Game) {
        self.game = game
    }
    
    var visibleRange: (xRange: Range<Int>, yRange: Range<Int>) {
        let halfSize = visibleSize / 2
        let centerX = game.character.position.x
        let centerY = game.character.position.y
        
        let minX = max(0, centerX - halfSize)
        let maxX = min(game.map.size, centerX + halfSize + 1)
        let minY = max(0, centerY - halfSize)
        let maxY = min(game.map.size, centerY + halfSize + 1)
        
        return (minX..<maxX, minY..<maxY)
    }
    
    func getPlayerPosition() -> (x: CGFloat, y: CGFloat) {
        let x = CGFloat(game.character.position.x - visibleRange.xRange.lowerBound) * cellSize + cellSize/2
        let y = CGFloat(game.character.position.y - visibleRange.yRange.lowerBound) * cellSize + cellSize/2
        return (x, y)
    }
} 