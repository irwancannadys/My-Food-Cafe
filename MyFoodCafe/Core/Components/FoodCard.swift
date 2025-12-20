//
//  FoodCard.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import SwiftUI
import Kingfisher

struct FoodCard: View {
    let food: FoodModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Image
                KFImage(URL(string: food.imageUrl))
                    .placeholder {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(Spacing.radiusMedium)
                
                // Info
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(food.name)
                        .font(.headlineSmall)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                    
                    Text(food.restaurantName)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                    
                    HStack(spacing: Spacing.xs) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.warning)
                        
                        Text(String(format: "%.1f", food.rating))
                            .font(.labelSmall)
                            .foregroundColor(.textSecondary)
                        
                        Spacer()
                        
                        Text("Rp \(Int(food.price).formatted())")
                            .font(.headlineSmall)
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer(minLength: 0)
            }
            .padding(Spacing.sm)
            .background(Color.white)
            .cornerRadius(Spacing.radiusMedium)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        FoodCard(food: FoodModel.mock, onTap: {})
        FoodCard(food: FoodModel.mockList[1], onTap: {})
    }
    .padding()
    .background(Color.background)
}
