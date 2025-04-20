import Foundation

class MapGenerator {
    static func generateMap(size: Int, resourceProbability: Double = 0.2) -> Map {
        let map = Map(size: size)
        
        for y in 0..<size {
            for x in 0..<size {
                if Double.random(in: 0...1) < resourceProbability {
                    map.updateCell(at: Position(x: x, y: y), type: .resource)
                }
            }
        }
        
        return map
    }
} 