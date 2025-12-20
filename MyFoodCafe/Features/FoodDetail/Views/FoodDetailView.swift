//
//  FoodDetailView.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import SwiftUI
import Kingfisher

struct FoodDetailView: View {
    let food: FoodModel
    @StateObject private var viewModel: FoodDetailViewModel
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss
    @State private var quantity: Int = 1
    
    var totalPrice: Double {
        food.price * Double(quantity)
    }
    
    init(food: FoodModel) {
        self.food = food
        _viewModel = StateObject(
            wrappedValue: FoodDetailViewModel(foodId: food.id)
        )
    }
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            switch viewModel.loadingState {
            case .idle:
                Text("Idle State")
                    .foregroundColor(.textSecondary)
                
            case .loading:
                VStack(spacing: Spacing.md) {
                    ProgressView()
                    Text("Loading food detail...")
                        .font(.bodyMedium)
                        .foregroundColor(.textSecondary)
                }
                
            case .success:
                if let foodDetail = viewModel.foodDetail {
                    contentView(foodDetail: foodDetail)
                } else {
                    Text("Success but no data")
                        .foregroundColor(.error)
                }
                
            case .failure(let error):
                errorView(message: error)
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchFoodDetail()
        }
    }
    
    private func contentView(foodDetail: FoodDetailModel) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                foodImageSection(imageUrl: foodDetail.imageUrl)
                
                VStack(spacing: Spacing.lg) {
                    headerSection(foodDetail: foodDetail)
                    Divider()
                    descriptionSection(foodDetail: foodDetail)
                    Divider()
                    restaurantSection(foodDetail: foodDetail)
                }
                .padding(Spacing.screenPadding)
            }
        }
        .safeAreaInset(edge: .bottom) {
            bottomBar(foodDetail: foodDetail)
        }
    }
    
    // MARK: - Food Image Section
    private func foodImageSection(imageUrl: String) -> some View {
        ZStack(alignment: .topLeading) {
            KFImage(URL(string: imageUrl))
                .placeholder {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .clipped()
            
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(Spacing.md)
        }
    }
    
    // MARK: - Header Section
    private func headerSection(foodDetail: FoodDetailModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text(foodDetail.name)
                .font(.displayMedium)
                .foregroundColor(.textPrimary)
            
            HStack {
                Image(systemName: "star.fill")
                    .font(.bodySmall)
                    .foregroundColor(.warning)
                
                Text(String(format: "%.1f", foodDetail.rating))
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                
                Text("(150+ ratings)")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Text("Rp \(Int(foodDetail.price).formatted())")
                .font(.headlineLarge)
                .foregroundColor(.primary)
            
            HStack(spacing: Spacing.xs) {
                Image(systemName: "heart")
                    .foregroundColor(.textPrimary)
                Text("Make Favorite")
            }
            .padding(Spacing.sm)
            .background(Color.cardBackground)
            .cornerRadius(Spacing.radiusMedium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Description Section
    private func descriptionSection(foodDetail: FoodDetailModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Description")
                .font(.headlineMedium)
                .foregroundColor(.textPrimary)
            
            Text(foodDetail.description)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Restaurant Section
    private func restaurantSection(foodDetail: FoodDetailModel) -> some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(foodDetail.restaurantName)
                    .font(.headlineSmall)
                    .foregroundColor(.textPrimary)
                
                Text(foodDetail.category)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.textSecondary)
        }
        .padding(Spacing.md)
        .background(Color.cardBackground)
        .cornerRadius(Spacing.radiusMedium)
    }
    
    // MARK: - Bottom Bar
    private func bottomBar(foodDetail: FoodDetailModel) -> some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack {
                // Quantity Selector
                HStack(spacing: Spacing.md) {
                    Button(action: {
                        viewModel.decreaseQuantity()
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(viewModel.quantity > 1 ? .primary : .gray)
                    }
                    .disabled(viewModel.quantity <= 1)
                    
                    Text("\(viewModel.quantity)")
                        .font(.headlineMedium)
                        .foregroundColor(.textPrimary)
                        .frame(minWidth: 30)
                    
                    Button(action: {
                        viewModel.increaseQuantity()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                // Add to Cart Button
                Button(action: {
                    // TODO: Add to cart logic
                    print("Added \(viewModel.totalPrice)x \(foodDetail.name) to cart")
                }) {
                    HStack {
                        Image(systemName: "cart.fill")
                        Text("Rp \(Int(viewModel.totalPrice).formatted())")
                            .fontWeight(.bold)
                    }
                    .font(.headlineSmall)
                    .foregroundColor(.white)
                    .padding(Spacing.md)
                    .background(Color.primary)
                    .cornerRadius(Spacing.radiusMedium)
                }
            }
            .padding(Spacing.screenPadding)
            .background(Color.white)
        }
    }
    
    private func errorView(message: String) -> some View {
            VStack(spacing: Spacing.md) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 50))
                    .foregroundColor(.error)
                
                Text("Failed to load")
                    .font(.headlineLarge)
                
                Text(message)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                
                Button("Try Again") {
                    Task {
                        await viewModel.fetchFoodDetail()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
}

#Preview {
    NavigationStack {
        FoodDetailView(food: FoodModel.mock)
            .environmentObject(Router())
    }
}
