import Foundation
import Combine

class Game: ObservableObject {
    @Published private(set) var map: Map
    @Published private(set) var character: Character
    @Published private(set) var gameLog: [LogEntry] = []
    @Published private(set) var isGameOver = false
    
    private var timer: Timer?
    private let mapSize: Int
    
    init(mapSize: Int = 100) {
        self.mapSize = mapSize
        let map = MapGenerator.generateMap(size: mapSize)
        self.map = map
        self.character = Character(
            startPosition: Position(x: mapSize / 2, y: mapSize / 2),
            initialEnergy: 1000,
            map: map
        )
        
        log("Game started", changes: [])
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.update()
        }
    }
    
    func restart() {
        // Stop current game
        timer?.invalidate()
        timer = nil
        
        // Reset game state
        isGameOver = false
        gameLog.removeAll()
        
        // Generate new map and character
        let newMap = MapGenerator.generateMap(size: mapSize)
        self.map = newMap
        self.character = Character(
            startPosition: Position(x: mapSize / 2, y: mapSize / 2),
            initialEnergy: 1000,
            map: newMap
        )
        
        log("Game restarted! Character energy: \(character.energy)", changes: [])
        
        // Start new game
        start()
    }
    
    private func update() {
        guard !isGameOver else { return }
        
        let result = character.move()
        
        if !result.changes.isEmpty {
            var message = "Moved to (\(character.position.x), \(character.position.y))"
            var changes: [LogChange] = []
            
            for change in result.changes {
                switch change.type {
                case .position:
                    // Position is already in the message
                    break
                case .energy:
                    changes.append(LogChange(type: .energy, value: change.value))
                case .resources:
                    message += " • Collected resource"
                    changes.append(LogChange(type: .collect, value: change.value))
                case .health:
                    // Not implemented yet
                    break
                }
            }
            
            log(message, changes: changes)
        } else {
            log("No resources in range", changes: [])
            endGame()
        }
        
        if !character.isAlive {
            log("Out of energy", changes: [])
            endGame()
        }
    }
    
    private func endGame() {
        isGameOver = true
        timer?.invalidate()
        timer = nil
        log("Final score: \(character.resourcesCollected)", changes: [])
    }
    
    private func log(_ message: String, changes: [LogChange]) {
        gameLog.append(LogEntry(message: message, changes: changes))
    }
} 