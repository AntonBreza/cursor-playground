import Foundation

class Character {
    private(set) var position: Position
    private(set) var energy: Int
    private(set) var resourcesCollected: Int
    private let visionRange: Int
    private let map: Map
    private let collectAction: CollectAction
    private let moveAction: MoveAction
    
    init(startPosition: Position, initialEnergy: Int, map: Map, visionRange: Int = GameConstants.Character.defaultVisionRange) {
        self.position = startPosition
        self.energy = initialEnergy
        self.map = map
        self.visionRange = visionRange
        self.resourcesCollected = 0
        self.collectAction = CollectAction(map: map)
        self.moveAction = MoveAction(map: map)
    }
    
    func move(to newPosition: Position) -> ActionResult {
        updatePosition(newPosition)
        let moveResult = moveAction.execute(character: self)
        let collectResult = tryCollectResources()
        return combineResults(moveResult: moveResult, collectResult: collectResult)
    }
    
    var isAlive: Bool {
        return energy > 0
    }
    
    func updatePosition(_ newPosition: Position) {
        position = newPosition
    }
    
    func updateEnergy(_ delta: Int) {
        energy += delta
    }
    
    func updateResources(_ delta: Int) {
        resourcesCollected += delta
    }
    
    func isPositionAdjacent(_ position: Position) -> Bool {
        return abs(position.x - self.position.x) <= 1 && abs(position.y - self.position.y) <= 1
    }
    
    private func tryCollectResources() -> ActionResult {
        return collectAction.execute(character: self)
    }
    
    private func combineResults(moveResult: ActionResult, collectResult: ActionResult) -> ActionResult {
        let totalCollectEnergyCost = collectResult.changes.filter { $0.type == .energy }.reduce(0) { $0 + $1.value }
        if energy + totalCollectEnergyCost < 0 {
            return moveResult
        }
        let allChanges = moveResult.changes + collectResult.changes
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