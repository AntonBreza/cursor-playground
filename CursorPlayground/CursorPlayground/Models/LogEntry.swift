import SwiftUI

enum LogType {
    case move
    case collect
    case energy
    case gameState
    
    var color: Color {
        switch self {
        case .move:
            return .blue
        case .collect:
            return .green
        case .energy:
            return .orange
        case .gameState:
            return .primary
        }
    }
    
    var symbol: String {
        switch self {
        case .move:
            return "figure.walk"
        case .collect:
            return "leaf.fill"
        case .energy:
            return "bolt.fill"
        case .gameState:
            return "info.circle"
        }
    }
}

struct LogChange {
    let type: LogType
    let value: Int
}

struct LogEntry: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let changes: [LogChange]
    
    init(message: String, changes: [LogChange] = []) {
        self.message = message
        self.changes = changes
    }
    
    static func == (lhs: LogEntry, rhs: LogEntry) -> Bool {
        lhs.id == rhs.id
    }
} 