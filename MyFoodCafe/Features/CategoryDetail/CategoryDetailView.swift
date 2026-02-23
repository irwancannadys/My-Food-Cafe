//
//  CategoryDetailView.swift
//  MyFoodCafe
//
//  Created by irwan on 23/02/26.
//


import SwiftUI

struct CategoryDetailView: View {
    let id: String
    
    @StateObject private var viewModel: CategoryDetailViewModel
    
    init(id: String) {
        self.id = id
        // Init ViewModel dengan foodId dari food yang dipilih
        _viewModel = StateObject(wrappedValue: CategoryDetailViewModel(foodId: id))
    }
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            switch viewModel.loadingState {
            case .idle, .loading:
                ProgressView("Loading via Alamofire...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .success:
                if let detail = viewModel.foodDetail {
                    scrollContent(detail: detail)
                }
                
            case .failure(let message):
                errorView(message: message)
            }
        }
        .navigationTitle("Category Detail")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // .task otomatis cancel kalau view di-dismiss
            if viewModel.loadingState == .idle {
                await viewModel.fetchData()
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    // MARK: - Scroll Content
    @ViewBuilder
    private func scrollContent(detail: CategoryFoodDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.lg) {
                
                // ── Food Header ──────────────────────────────
                AsyncImage(url: URL(string: detail.imageUrl)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Rectangle().fill(Color.gray.opacity(0.2))
                }
                .frame(height: 250)
                .clipped()
                
                VStack(alignment: .leading, spacing: Spacing.md) {
                    
                    // Badge: menunjukkan ini load pakai Alamofire
                    HStack {
                        Label("Loaded with Alamofire", systemImage: "network")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.orange)
                            .cornerRadius(8)
                        Spacer()
                    }
                    
                    Text(detail.name)
                        .font(.title2.bold())
                    
                    Text(detail.longDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // ── Nutrition Info ───────────────────────
                    nutritionSection(nutrition: detail.nutrition)
                    
                    // ── Ingredients ─────────────────────────
                    ingredientsSection(ingredients: detail.ingredients)
                    
                    // ── Categories dari API ──────────────────
                    if !viewModel.categories.isEmpty {
                        categoriesSection
                    }
                }
                .padding(.horizontal, Spacing.screenPadding)
                .padding(.bottom, Spacing.xl)
            }
        }
    }
    
    // MARK: - Nutrition Section
    private func nutritionSection(nutrition: CategoryFoodDetail.Nutrition) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Nutrition")
                .font(.headline)
            
            HStack(spacing: Spacing.md) {
                nutritionItem(label: "Calories", value: "\(nutrition.calories)")
                nutritionItem(label: "Protein", value: nutrition.protein)
                nutritionItem(label: "Carbs", value: nutrition.carbs)
                nutritionItem(label: "Fat", value: nutrition.fat)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(Spacing.radiusMedium)
    }
    
    private func nutritionItem(label: String, value: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.subheadline.bold())
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Ingredients Section
    private func ingredientsSection(ingredients: [String]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Ingredients")
                .font(.headline)
            
            // Tampil sebagai chip/tag
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 100))],
                alignment: .leading,
                spacing: Spacing.xs
            ) {
                ForEach(ingredients, id: \.self) { ingredient in
                    Text(ingredient)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.primary.opacity(0.1))
                        .foregroundColor(.primary)
                        .cornerRadius(20)
                }
            }
        }
    }
    
    // MARK: - Categories Section (data dari Alamofire)
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("All Categories")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.categories.count) items")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(viewModel.categories) { category in
                HStack(spacing: Spacing.md) {
                    Image(systemName: category.icon)
                        .frame(width: 32, height: 32)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(category.name)
                            .font(.subheadline.bold())
                        Text("\(category.totalItems) items")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(Spacing.radiusMedium)
            }
        }
    }
    
    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack(spacing: Spacing.md) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Gagal Load")
                .font(.headline)
            
            Text(message)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.xl)
            
            Button("Coba Lagi") {
                Task { await viewModel.fetchData() }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
