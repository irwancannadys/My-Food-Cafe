//
//  SearchBar.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search for food..."
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
                .font(.bodyMedium)
            
            if let onTap = onTap {
                Text(text.isEmpty ? placeholder : text)
                    .foregroundColor(text.isEmpty ? .textSecondary : .textPrimary)
                    .font(.bodyMedium)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                // Editable search
                TextField(placeholder, text: $text)
                    .font(.bodyMedium)
            }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.sm)
        .background(Color.cardBackground)
        .cornerRadius(Spacing.radiusMedium)
        .onTapGesture {
            onTap?()
        }
    }
}

#Preview {
    VStack {
        SearchBar(text: .constant(""))
        SearchBar(text: .constant("Nasi Goreng"))
    }
    .padding()
}
