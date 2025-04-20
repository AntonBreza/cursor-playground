import Foundation

class Character {
    private(set) var position: Position
    private(set) var energy: Int
    private(set) var resourcesCollected: Int
    private let visionRange: Int
    private let map: Map
    private let moveAction: MoveAction
    private let collectAction: CollectAction
    
    init(startPosition: Position, initialEnergy: Int, map: Map, visionRange: Int = 2) {
        self.position = startPosition
        self.energy = initialEnergy
        self.map = map
        self.visionRange = visionRange
        self.resourcesCollected = 0
        self.moveAction = MoveAction(map: map, visionRange: visionRange)
        self.collectAction = CollectAction(map: map)
    }
    
    func move() -> ActionResult {
        let moveResult = moveAction.execute(character: self)
        let collectResult = collectAction.execute(character: self)
        
        // Apply all changes from both actions
        let allChanges = moveResult.changes + collectResult.changes
        for change in allChanges {
            switch change.type {
            case .position:
                // Position is already updated by the actions
                break
            case .energy:
                energy += change.value
            case .resources:
                resourcesCollected += change.value
            case .health:
                // Not implemented yet
                break
            }
        }
        
        return ActionResult(changes: allChanges)
    }
    
    var isAlive: Bool {
        return energy > 0
    }
    
    // MARK: - Property Modifiers
    
    func updatePosition(_ newPosition: Position) {
        position = newPosition
    }
    
    func updateEnergy(_ delta: Int) {
        energy += delta
    }
    
    func updateResources(_ delta: Int) {
        resourcesCollected += delta
    }
} 