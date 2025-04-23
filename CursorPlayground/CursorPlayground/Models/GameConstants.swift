import Foundation

enum GameConstants {
    enum Movement {
        static let energyCost = 5
        static let positionChange = 1
    }
    
    enum Collection {
        static let resourceChange = 1
        static let energyCost = 1
    }
    
    enum Character {
        static let initialEnergy = 1000
        static let defaultVisionRange = 2
    }
} 