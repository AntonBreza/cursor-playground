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
        // First evaluate if we can perform the move action
        let moveResult = moveAction.execute(character: self)
        let totalEnergyCost = moveResult.changes.filter { $0.type == .energy }.reduce(0) { $0 + $1.value }
        
        // If moving would make energy negative, don't move
        if energy + totalEnergyCost < 0 {
            return .empty()
        }
        
        // Mark the new cell as visited
        map.markCellAsVisited(at: position)
        
        // Then evaluate if we can collect resources
        let collectResult = collectAction.execute(character: self)
        let totalCollectEnergyCost = collectResult.changes.filter { $0.type == .energy }.reduce(0) { $0 + $1.value }
        
        // If collecting would make energy negative, only apply move changes
        if energy + totalEnergyCost + totalCollectEnergyCost < 0 {
            // Apply only move changes
            for change in moveResult.changes {
                switch change.type {
                case .position:
                    // Position is already updated by the action
                    break
                case .energy:
                    energy += change.value
                case .resources, .health:
                    break
                }
            }
            return moveResult
        }
        
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