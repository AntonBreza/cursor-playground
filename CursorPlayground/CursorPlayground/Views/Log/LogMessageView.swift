import SwiftUI

struct LogMessageView: View {
    let entry: LogEntry
    
    var body: some View {
        Text(attributedString)
            .font(.system(size: 12, design: .monospaced))
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    private var attributedString: AttributedString {
        var result = AttributedString("")
        
        // Add changes first
        for (index, change) in entry.changes.enumerated() {
            if index > 0 {
                result.append(AttributedString(" "))
            }
            
            // Add SF Symbol
            var symbol = AttributedString(change.type.symbol)
            symbol.foregroundColor = change.type.color
            result.append(symbol)
            
            // Add value
            var value = AttributedString(" \(change.value > 0 ? "+" : "")\(change.value)")
            value.foregroundColor = change.type.color
            result.append(value)
        }
        
        // Add message
        if !entry.changes.isEmpty {
            result.append(AttributedString(" "))
        }
        var message = AttributedString(entry.message)
        message.foregroundColor = .primary
        result.append(message)
        
        return result
    }
} 