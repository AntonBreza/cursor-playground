import Foundation
import Combine

class Game: ObservableObject {
    @Published private(set) var map: Map
    @Published private(set) var character: Character
    @Published private(set) var gameLog: [LogEntry] = []
    @Published private(set) var isGameOver = false
    
    private let mapSize: Int
    
    init(mapSize: Int = 100) {
        self.mapSize = mapSize
        let map = MapGenerator.generateMap(size: mapSize)
        self.map = map
        self.character = Character(
            startPosition: Position(x: mapSize / 2, y: mapSize / 2),
            initialEnergy: GameConstants.Character.initialEnergy,
            map: map
        )
        log("Game started", changes: [])
    }
    
    func restart() {
        isGameOver = false
        gameLog.removeAll()
        let newMap = MapGenerator.generateMap(size: mapSize)
        self.map = newMap
        self.character = Character(
            startPosition: Position(x: mapSize / 2, y: mapSize / 2),
            initialEnergy: GameConstants.Character.initialEnergy,
            map: newMap
        )
        log("Game restarted! Character energy: \(character.energy)", changes: [])
    }
    
    func moveCharacter(to position: Position) {
        guard !isGameOver else { return }
        if character.isPositionAdjacent(position) {
            let result = character.move(to: position)
            if !result.changes.isEmpty {
                var message = "Moved to (\(character.position.x), \(character.position.y))"
                var changes: [LogChange] = []
                for change in result.changes {
                    switch change.type {
                    case .position:
                        break
                    case .energy:
                        changes.append(LogChange(type: .energy, value: change.value))
                    case .resources:
                        message += " • Collected resource"
                        changes.append(LogChange(type: .collect, value: change.value))
                    case .health:
                        break
                    }
                }
                log(message, changes: changes)
            }
            if !character.isAlive {
                log("Out of energy", changes: [])
                endGame()
            }
        }
    }
    
    private func endGame() {
        isGameOver = true
        log("Final score: \(character.resourcesCollected)", changes: [])
    }
    
    private func log(_ message: String, changes: [LogChange]) {
        gameLog.append(LogEntry(message: message, changes: changes))
    }
} 