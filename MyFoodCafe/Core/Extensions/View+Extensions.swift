//
//  View+Extensions.swift
//  MyFoodCafe
//
//  Created by irwan on 19/12/25.
//

import SwiftUI

extension View {
    // MARK: - Conditional Modifiers
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    // MARK: - Corner Radius (Specific corners)
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    // MARK: - Card Style
    func cardStyle(padding: CGFloat = Spacing.cardPadding, radius: CGFloat = Spacing.radiusMedium) -> some View {
        self
            .padding(padding)
            .background(Color.cardBackground)
            .cornerRadius(radius)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Loading Overlay
    func loading(_ isLoading: Bool) -> some View {
        self.overlay(
            Group {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        )
    }
}

// MARK: - Custom Shape for specific corner radius
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
