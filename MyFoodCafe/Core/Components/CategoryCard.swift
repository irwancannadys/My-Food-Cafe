//
//  CategoryCard.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import SwiftUI

struct CategoryCard: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: Spacing.iconMedium))
                    .foregroundColor(isSelected ? .white : .primary)
                    .frame(width: 60, height: 60)
                    .background(isSelected ? Color.primary : Color.tertiary)
                    .cornerRadius(Spacing.radiusMedium)
                
                Text(title)
                    .font(.labelSmall)
                    .foregroundColor(isSelected ? .primary : .textSecondary)
                    .lineLimit(1)
            }
            .frame(width: 80)
        }
    }
}

#Preview {
    HStack(spacing: Spacing.md) {
        CategoryCard(
            icon: "flame.fill",
            title: "Popular",
            isSelected: true,
            action: {}
        )
        CategoryCard(
            icon: "fork.knife",
            title: "Main Course",
            isSelected: false,
            action: {}
        )
        CategoryCard(
            icon: "cup.and.saucer.fill",
            title: "Drinks",
            isSelected: false,
            action: {}
        )
    }
    .padding()
}
