import Foundation
import SwiftUI

class MapGenerator {
    static func generateMap(size: Int, resourceProbability: Double = 0.2) -> Map {
        let map = Map(size: size)
        
        for y in 0..<size {
            for x in 0..<size {
                let backgroundColor = Color(
                    red: Double.random(in: 0.9...1.0),
                    green: Double.random(in: 0.9...1.0),
                    blue: Double.random(in: 0.9...1.0)
                )
                
                if Double.random(in: 0...1) < resourceProbability {
                    map.updateCell(at: Position(x: x, y: y), type: .resource, backgroundColor: backgroundColor)
                } else {
                    map.updateCell(at: Position(x: x, y: y), type: .empty, backgroundColor: backgroundColor)
                }
            }
        }
        
        return map
    }
} 