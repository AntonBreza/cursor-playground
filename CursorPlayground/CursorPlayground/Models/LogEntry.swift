import SwiftUI

enum LogType {
    case move
    case collect
    case gameState
    
    var color: Color {
        switch self {
        case .move:
            return .blue
        case .collect:
            return .green
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
        case .gameState:
            return "info.circle"
        }
    }
}

struct LogEntry: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let type: LogType
    let value: Int?
    
    init(message: String, type: LogType, value: Int? = nil) {
        self.message = message
        self.type = type
        self.value = value
    }
    
    static func == (lhs: LogEntry, rhs: LogEntry) -> Bool {
        lhs.id == rhs.id
    }
} 