import Foundation
import Combine

class Game: ObservableObject {
    @Published private(set) var map: Map
    @Published private(set) var character: Character
    @Published private(set) var gameLog: [String] = []
    @Published private(set) var isGameOver = false
    
    private var timer: Timer?
    
    init(mapSize: Int = 100) {
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