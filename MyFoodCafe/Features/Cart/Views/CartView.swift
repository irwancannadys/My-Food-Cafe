//
//  CartView.swift
//  MyFoodCafe
//
//  Created by irwan on 29/12/25.
//
import Foundation
import SwiftUI

struct CartView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                        .background(Color.black.opacity(0.1))
                        .clipShape(Circle())
                }
                .padding(.leading, Spacing.md)
                .padding(.top, Spacing.sm)
                .padding(.bottom, Spacing.sm)

                Text("Cart")
                    .font(.displayMedium)
                    .padding(.leading, Spacing.xs)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0..<1000, id: \.self) { index in
                        Text("Item \(index)")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .safeAreaInset(edge: .bottom) {
                bottomBarCheckout
            }
        }
        .navigationBarHidden(true)
    }
    
    private var bottomBarCheckout: some View {
        VStack(alignment: .leading ,spacing: 0) {
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text("Total")
                        .font(.bodyMedium)
                    Text("Rp275.000")
                        .font(.headlineLarge)
                }
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    HStack {
                        Text("Checkout")
                            .fontWeight(.bold)

                    }
                    .font(.headlineSmall)
                    .foregroundColor(.white)
                    .padding(Spacing.md)
                    .background(Color.primary)
                    .cornerRadius(Spacing.radiusMedium)
                }
            }
            .padding(Spacing.md)
            .background(Color.white)
        }
    }
}

#Preview {
    CartView()
}
