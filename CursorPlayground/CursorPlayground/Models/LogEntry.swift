import SwiftUI

enum LogType {
    case energy
    case resource
    case gameState
    
    var color: Color {
        switch self {
        case .energy:
            return .blue
        case .resource:
            return .green
        case .gameState:
            return .primary
        }
    }
}

struct LogEntry: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let type: LogType
    
    static func == (lhs: LogEntry, rhs: LogEntry) -> Bool {
        lhs.id == rhs.id
    }
} 