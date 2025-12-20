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
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: FoodDetailViewModel
    
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
        .refreshable {
            await viewModel.refresh()
        }
        .task {
            await viewModel.fetchFoodDetail()
        }
    }
    
    // MARK: - Content View
    private func contentView(foodDetail: FoodDetailModel) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                foodImageSection(imageUrl: foodDetail.imageUrl)
                VStack(spacing: Spacing.lg) {
                    headerSection(foodDetail: foodDetail)
                    Divider()
                    descriptionSection(foodDetail: foodDetail)
                    Divider()
                    ingredientsSection(foodDetail: foodDetail)
                    Divider()
                    nutritionSection(foodDetail: foodDetail)
                    Divider()
                    restaurantSection(foodDetail: foodDetail)
                }
                .padding(Spacing.screenPadding)
            }
        }
        .navigationBarHidden(true)
        .safeAreaInset(edge: .bottom) {
            bottomBar
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
            
            HStack {
                // Back button
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
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "cart.fill")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                }
                .padding(.trailing, Spacing.md)
            }
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
                
                Text("(\(foodDetail.totalReviews)+ ratings)")
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
            }
            
            HStack {
                Text("Rp \(Int(foodDetail.price).formatted())")
                    .font(.headlineLarge)
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "clock")
                        .font(.bodySmall)
                    Text(foodDetail.deliveryTime)
                        .font(.bodySmall)
                }
                .foregroundColor(.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Description Section
    private func descriptionSection(foodDetail: FoodDetailModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Description")
                .font(.headlineMedium)
                .foregroundColor(.textPrimary)
            
            Text(foodDetail.longDescription)
                .font(.bodyMedium)
                .foregroundColor(.textSecondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Ingredients Section
    private func ingredientsSection(foodDetail: FoodDetailModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Ingredients")
                .font(.headlineMedium)
                .foregroundColor(.textPrimary)
            
            FlowLayout(spacing: Spacing.xs) {
                ForEach(foodDetail.ingredients, id: \.self) { ingredient in
                    Text(ingredient)
                        .font(.bodySmall)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, Spacing.sm)
                        .padding(.vertical, Spacing.xs)
                        .background(Color.tertiary)
                        .cornerRadius(Spacing.radiusSmall)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Nutrition Section
    private func nutritionSection(foodDetail: FoodDetailModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Nutrition Facts")
                .font(.headlineMedium)
                .foregroundColor(.textPrimary)
            
            HStack(spacing: Spacing.lg) {
                NutritionItem(
                    label: "Calories",
                    value: "\(foodDetail.nutrition.calories)"
                )
                NutritionItem(
                    label: "Protein",
                    value: foodDetail.nutrition.protein
                )
                NutritionItem(label: "Carbs", value: foodDetail.nutrition.carbs)
                NutritionItem(label: "Fat", value: foodDetail.nutrition.fat)
            }
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
                
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.warning)
                    Text(String(format: "%.1f", foodDetail.restaurantRating))
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                }
                
                Text(foodDetail.restaurantAddress)
                    .font(.bodySmall)
                    .foregroundColor(.textSecondary)
                    .lineLimit(1)
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
    private var bottomBar: some View {
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
                            .foregroundColor(
                                viewModel.quantity > 1 ? .primary : .gray
                            )
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
                    viewModel.addToCart()
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
    
    // MARK: - Error View
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

// MARK: - Nutrition Item Component
struct NutritionItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Text(value)
                .font(.headlineSmall)
                .foregroundColor(.textPrimary)
            Text(label)
                .font(.caption)
                .foregroundColor(.textSecondary)
        }
    }
}

// MARK: - Flow Layout (for ingredients tags)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview
                .place(
                    at: CGPoint(
                        x: bounds.minX + result.positions[index].x,
                        y: bounds.minY + result.positions[index].y
                    ),
                    proposal: .unspecified
                )
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

#Preview {
    NavigationStack {
        FoodDetailView(food: FoodModel.mock)
            .environmentObject(Router())
    }
}
