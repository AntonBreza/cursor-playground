import SwiftUI

struct LogMessageView: View {
    let entry: LogEntry
    
    var body: some View {
        let text = entry.changes.enumerated().reduce(Text("")) { result, change in
            let (index, logChange) = change
            
            return result + 
                   (index > 0 ? Text(" ") : Text("")) +
                   Text(Image(systemName: logChange.type.symbol))
                       .foregroundColor(logChange.type.color)
                       .baselineOffset(1) +
                   Text(" \(logChange.value > 0 ? "+" : "")\(logChange.value)")
                       .foregroundColor(logChange.type.color)
        }
        
        (text + 
         (!entry.changes.isEmpty ? Text(" ") : Text("")) +
         Text(entry.message)
            .foregroundColor(.primary))
            .font(.system(size: 12, design: .monospaced))
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
} 