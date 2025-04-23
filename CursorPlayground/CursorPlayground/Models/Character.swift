import Foundation

class Character {
    private(set) var position: Position
    private(set) var energy: Int
    private(set) var resourcesCollected: Int
    private let visionRange: Int
    private let map: Map
    private let collectAction: CollectAction
    
    init(startPosition: Position, initialEnergy: Int, map: Map, visionRange: Int = 2) {
        self.position = startPosition
        self.energy = initialEnergy
        self.map = map
        self.visionRange = visionRange
        self.resourcesCollected = 0
        self.collectAction = CollectAction(map: map)
    }
    
    func move(to newPosition: Position) -> ActionResult {
        // First check if we can move to the new position
        guard map.cell(at: newPosition) != nil else {
            return .empty()
        }
        
        // Calculate energy cost for movement
        let energyCost = 5
        if energy - energyCost < 0 {
            return .empty()
        }
        
        // Update position and energy
        updatePosition(newPosition)
        updateEnergy(-energyCost)
        
        // Mark the new cell as visited
        map.markCellAsVisited(at: newPosition)
        
        // Then evaluate if we can collect resources
        let collectResult = collectAction.execute(character: self)
        let totalCollectEnergyCost = collectResult.changes.filter { $0.type == .energy }.reduce(0) { $0 + $1.value }
        
        // If collecting would make energy negative, only apply move changes
        if energy + totalCollectEnergyCost < 0 {
            return ActionResult(changes: [
                .init(type: .position, value: 1),
                .init(type: .energy, value: -energyCost)
            ])
        }
        
        // Apply all changes from both actions
        let allChanges = [
            ActionResult.Change(type: .position, value: 1),
            ActionResult.Change(type: .energy, value: -energyCost)
        ] + collectResult.changes
        
        for change in collectResult.changes {
            switch change.type {
            case .energy:
                energy += change.value
            case .resources:
                resourcesCollected += change.value
            case .position, .health:
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