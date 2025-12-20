//
//  BannerCard.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import SwiftUI
import Kingfisher

struct BannerCard: View {
    let imageUrl: String
    let title: String
    let subtitle: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            KFImage(URL(string: imageUrl))
                .placeholder {
                    Rectangle()
                        .fill(Color.primary.opacity(0.2))
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipped()
            
            // Gradient Overlay
            LinearGradient(
                colors: [Color.black.opacity(0.6), Color.clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 180)
            
            // Text Content
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(title)
                    .font(.headlineLarge)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Text(subtitle)
                    .font(.bodyMedium)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(Spacing.md)
        }
        .frame(height: 180)
        .cornerRadius(Spacing.radiusLarge)
    }
}

#Preview {
    VStack {
        BannerCard(
            imageUrl: "https://picsum.photos/400/200?random=1",
            title: "Free Delivery",
            subtitle: "For orders above Rp 50.000"
        )
        
        BannerCard(
            imageUrl: "https://picsum.photos/400/200?random=2",
            title: "50% Off",
            subtitle: "On your first order"
        )
    }
    .padding()
}
