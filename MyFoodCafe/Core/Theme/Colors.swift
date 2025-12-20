//
//  Colors.swift
//  MyFoodCafe
//
//  Created by irwan on 19/12/25.
//

import SwiftUI

extension Color {
    // MARK: - Brand Colors
    static let primaryDark = Color(hex: "8D6E63")
    static let primary = Color(hex: "A1887F")     // Brown
    static let secondary = Color(hex: "BCAAA4")   // Light Brown
    static let tertiary = Color(hex: "D7CCC8")    // Very Light Brown
    
    // MARK: - Semantic Colors
    static let background = Color.white
    static let cardBackground = Color(hex: "F5F5F5")
    static let textPrimary = Color(hex: "212121")
    static let textSecondary = Color(hex: "757575")
    
    // MARK: - Functional Colors
    static let success = Color(hex: "4CAF50")
    static let error = Color(hex: "F44336")
    static let warning = Color(hex: "FF9800")
    static let info = Color(hex: "2196F3")
    
    // MARK: - Helper: Hex to Color
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
            (a, r, g, b) = (255, 0, 0, 0)
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
