import Foundation
import Combine

class Game: ObservableObject {
    @Published private(set) var map: Map
    @Published private(set) var character: Character
    @Published private(set) var gameLog: [String] = []
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
        
        log("Game started! Character energy: \(character.energy)")
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
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
        
        log("Game restarted! Character energy: \(character.energy)")
        
        // Start new game
        start()
    }
    
    private func update() {
        guard !isGameOver else { return }
        
        if character.move() {
            log("Character moved to (\(character.position.x), \(character.position.y)). Energy: \(character.energy)")
        } else {
            log("No resources in range. Game Over!")
            endGame()
        }
        
        if !character.isAlive {
            log("Character ran out of energy. Game Over!")
            endGame()
        }
    }
    
    private func endGame() {
        isGameOver = true
        timer?.invalidate()
        timer = nil
        log("Final score: \(character.resourcesCollected) resources collected")
    }
    
    private func log(_ message: String) {
        gameLog.append(message)
        if gameLog.count > 10 {
            gameLog.removeFirst()
        }
    }
} 