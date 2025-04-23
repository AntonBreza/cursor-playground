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
    
    static func move() -> ActionResult {
        ActionResult(changes: [
            .init(type: .position, value: GameConstants.Movement.positionChange),
            .init(type: .energy, value: -GameConstants.Movement.energyCost)
        ])
    }
    
    static func collect() -> ActionResult {
        ActionResult(changes: [
            .init(type: .resources, value: GameConstants.Collection.resourceChange),
            .init(type: .energy, value: -GameConstants.Collection.energyCost)
        ])
    }
}
