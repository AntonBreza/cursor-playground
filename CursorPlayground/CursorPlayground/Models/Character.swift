import Foundation

class Character {
    private(set) var position: Position
    private(set) var energy: Int
    private(set) var resourcesCollected: Int
    private let visionRange: Int
    private let map: Map
    private let collectAction: CollectAction
    
    init(startPosition: Position, initialEnergy: Int, map: Map, visionRange: Int = GameConstants.Character.defaultVisionRange) {
        self.position = startPosition
        self.energy = initialEnergy
        self.map = map
        self.visionRange = visionRange
        self.resourcesCollected = 0
        self.collectAction = CollectAction(map: map)
    }
    
    func move(to newPosition: Position) -> ActionResult {
        // Validate the move
        guard canMove(to: newPosition) else {
            return .empty()
        }
        
        // Execute the move
        let moveResult = executeMove(to: newPosition)
        
        // Try to collect resources if possible
        let collectResult = tryCollectResources()
        
        // Combine and apply results
        return combineResults(moveResult: moveResult, collectResult: collectResult)
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
    
    // MARK: - Movement Helpers
    
    private func canMove(to newPosition: Position) -> Bool {
        guard map.cell(at: newPosition) != nil else {
            return false
        }
        
        return energy - GameConstants.Movement.energyCost >= 0
    }
    
    private func executeMove(to newPosition: Position) -> ActionResult {
        // Update position and energy
        updatePosition(newPosition)
        updateEnergy(-GameConstants.Movement.energyCost)
        
        // Mark the new cell as visited
        map.markCellAsVisited(at: newPosition)
        
        return ActionResult(changes: [
            .init(type: .position, value: GameConstants.Movement.positionChange),
            .init(type: .energy, value: -GameConstants.Movement.energyCost)
        ])
    }
    
    private func tryCollectResources() -> ActionResult {
        return collectAction.execute(character: self)
    }
    
    private func combineResults(moveResult: ActionResult, collectResult: ActionResult) -> ActionResult {
        let totalCollectEnergyCost = collectResult.changes.filter { $0.type == .energy }.reduce(0) { $0 + $1.value }
        
        // If collecting would make energy negative, only apply move changes
        if energy + totalCollectEnergyCost < 0 {
            return moveResult
        }
        
        // Apply all changes from both actions
        let allChanges = moveResult.changes + collectResult.changes
        
        // Apply changes to character state
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
} 