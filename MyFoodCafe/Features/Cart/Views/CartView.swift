//
//  CartView.swift
//  MyFoodCafe
//
//  Created by irwan on 29/12/25.
//
import Foundation
import SwiftUI
import Kingfisher

struct CartView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cartManager: CartManager
    @State private var showClearAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            headerSection
            
            if cartManager.cartItems.isEmpty {
                emptyCartView
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: Spacing.md) {
                        ForEach(cartManager.cartItems) { item in
                            CartItemRow(
                                item: item,
                                onIncrease: {
                                    cartManager.increaseQuantity(item: item)
                                },
                                onDecrease: {
                                    cartManager.decreaseQuantity(item: item)
                                },
                                onRemove: {
                                    cartManager.removeItem(item)
                                }
                            )
                        }
                    }
                    .padding(Spacing.md)
                }
                .safeAreaInset(edge: .bottom) {
                    bottomBarCheckout
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            cartManager.fetchCartItems()
        }
        .alert("Clear Cart?", isPresented: $showClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                cartManager.clearCart()
            }
        } message: {
            Text("Are you sure you want to remove all items from your cart?")
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
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
            
            Spacer()
            
            if !cartManager.cartItems.isEmpty {
                Button(action: {
                    showClearAlert = true
                }) {
                    Text("Clear")
                        .font(.bodyMedium)
                        .foregroundColor(.error)
                }
                .padding(.trailing, Spacing.md)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Empty Cart View
    private var emptyCartView: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()
            
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.textSecondary)
            
            Text("Your cart is empty")
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
            
            Text("Add items to get started")
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
            
            Button(action: {
                dismiss()
            }) {
                Text("Start Shopping")
                    .font(.headlineSmall)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, Spacing.xl)
                    .padding(.vertical, Spacing.md)
                    .background(Color.primary)
                    .cornerRadius(Spacing.radiusMedium)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Bottom Bar Checkout
    private var bottomBarCheckout: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            
            // Summary
            VStack(spacing: Spacing.sm) {
                HStack {
                    Text("Subtotal (\(cartManager.totalItems) items)")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text("Rp \(Int(cartManager.totalAmount).formatted())")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                }
                
                HStack {
                    Text("Delivery Fee")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    Text("Rp 10.000")
                        .font(.bodyMedium)
                        .foregroundColor(.textPrimary)
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.headlineMedium)
                        .foregroundColor(.textPrimary)
                    Spacer()
                    Text("Rp \(Int(cartManager.totalAmount + 10000).formatted())")
                        .font(.headlineLarge)
                        .foregroundColor(.primary)
                }
            }
            .padding(Spacing.md)
            
            // Checkout Button
            Button(action: {
                // TODO: Navigate to checkout
                print("Proceed to checkout")
            }) {
                HStack {
                    Text("Checkout")
                        .fontWeight(.bold)
                }
                .font(.headlineSmall)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(Spacing.md)
                .background(Color.primary)
                .cornerRadius(Spacing.radiusMedium)
            }
            .padding(.horizontal, Spacing.md)
            .padding(.bottom, Spacing.md)
        }
        .background(Color.white)
    }
}

// MARK: - Cart Item Row
struct CartItemRow: View {
    let item: CartItem
    let onIncrease: () -> Void
    let onDecrease: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            // Food Image
            KFImage(URL(string: item.imageUrl))
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(Spacing.radiusSmall)
                .clipped()
            
            // Info
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(item.name)
                    .font(.headlineSmall)
                    .foregroundColor(.textPrimary)
                    .lineLimit(2)
                
                Text(item.restaurantName)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                
                Text("Rp \(Int(item.price).formatted())")
                    .font(.bodyMedium)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            // Quantity Controls
            VStack(spacing: Spacing.sm) {
                // Quantity selector
                HStack(spacing: Spacing.xs) {
                    Button(action: onDecrease) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title3)
                            .foregroundColor(item.quantity > 1 ? .primary : .gray)
                    }
                    
                    Text("\(item.quantity)")
                        .font(.bodyMedium)
                        .fontWeight(.semibold)
                        .foregroundColor(.textPrimary)
                        .frame(minWidth: 25)
                    
                    Button(action: onIncrease) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                // Remove button
                HStack(spacing: Spacing.xs) {
                    Button(action: onRemove) {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundColor(.error)
                    }
                    Text("Hapus")
                        .font(.bodyMedium)
                        .foregroundColor(.error)
                }
                
            }
        }
        .padding(Spacing.md)
        .background(Color.cardBackground)
        .cornerRadius(Spacing.radiusMedium)
    }
}

#Preview {
    NavigationStack {
        CartView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(CartManager(context: PersistenceController.preview.container.viewContext))
    }
}
