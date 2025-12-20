//
//  Spacing.swift
//  MyFoodCafe
//
//  Created by irwan on 19/12/25.
//

import SwiftUI

enum Spacing {
    // MARK: - Base Spacing (8pt grid system)
    static let xxxs: CGFloat = 2
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 40
    static let xxxl: CGFloat = 48
    
    // MARK: - Specific Use Cases
    static let cardPadding: CGFloat = md
    static let screenPadding: CGFloat = md
    static let sectionSpacing: CGFloat = lg
    static let itemSpacing: CGFloat = sm
    
    // MARK: - Corner Radius
    static let radiusSmall: CGFloat = 8
    static let radiusMedium: CGFloat = 12
    static let radiusLarge: CGFloat = 16
    static let radiusXLarge: CGFloat = 24
    
    // MARK: - Icon Sizes
    static let iconSmall: CGFloat = 16
    static let iconMedium: CGFloat = 24
    static let iconLarge: CGFloat = 32
    static let iconXLarge: CGFloat = 48
}
