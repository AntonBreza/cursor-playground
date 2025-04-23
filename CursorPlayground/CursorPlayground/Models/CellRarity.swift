import SwiftUI

enum CellRarity: CaseIterable {
    case common
    case uncommon
    case rare
    case epic
    case legendary
    
    var color: Color {
        switch self {
        case .common:
            return Color(hex: "B0BEC5") // Ash Gray
        case .uncommon:
            return Color(hex: "4DB6AC") // Cool Mint
        case .rare:
            return Color(hex: "5C6BC0") // Twilight Blue
        case .epic:
            return Color(hex: "FF7043") // Sunset Flame
        case .legendary:
            return Color(hex: "D81B60") // Royal Magenta
        }
    }
    
    var borderWidth: CGFloat {
        return 1.5
    }
}

// Extension to create Color from hex string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 