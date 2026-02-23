//
//  HomeView.swift
//  MyFoodCafe
//
//  Created by irwan on 19/12/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "Popular"
    @State private var currentBannerPage: Int = 0
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
                    headerView
                       
                    // Search Bar
                    SearchBar(text: $searchText) {
                        router.navigate(to: .search)
                    }
                    .padding(.horizontal, Spacing.screenPadding)
                       
                    // Loading State
                    if viewModel.loadingState == .loading {
                        ProgressView()
                            .padding(.top, 100)
                    } else {
                        // Banner Slider
                        if !viewModel.banners.isEmpty {
                            bannerSection
                        }
                           
                        // Categories
                        if !viewModel.categories.isEmpty {
                            categorySection
                        }
                           
                        // Popular Foods
                        if !viewModel.foods.isEmpty {
                            foodSection
                        }
                    }
                }
            }
            .background(Color.background)
            .refreshable {
                await viewModel.refresh()
            }
            
            if case .failure(let error) = viewModel.loadingState {
                errorOverlay(message: error)
            }
        }
        .onAppear {
            print("👀 [HomeView] onAppear triggered - loadingState: \(viewModel.loadingState)")
            if viewModel.loadingState == .idle {
                print("👀 [HomeView] State is idle, fetching data...")
                Task {
                    await viewModel.fetchHomeData()
                }
            } else {
                print("👀 [HomeView] State is not idle, skipping fetch")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Deliver to")
                    .font(.labelSmall)
                    .foregroundColor(.textSecondary)
                        
                HStack(spacing: Spacing.xxs) {
                    Image(systemName: "location.fill")
                        .font(.labelSmall)
                        .foregroundColor(.primary)
                            
                    Text("Pasarkemis, West Java")
                        .font(.headlineSmall)
                        .foregroundColor(.textPrimary)
                            
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
            }
                    
            Spacer()
                    
            // Notification Button
            Button(action: {}) {
                Image(systemName: "bell.fill")
                    .font(.title3)
                    .foregroundColor(.textPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.cardBackground)
                    .cornerRadius(Spacing.radiusMedium)
            }
        }
        .padding(.horizontal, Spacing.screenPadding)
        .padding(.top, Spacing.sm)
    }
    
    private var bannerSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            GeometryReader { geometry in
                TabView(selection: $currentBannerPage) {
                    ForEach(
                        Array(viewModel.banners.enumerated()),
                        id: \.offset
                    ) { index, banner in
                        BannerCard(
                            imageUrl: banner.imageUrl,
                            title: banner.title,
                            subtitle: banner.subtitle
                        )
                        .padding(.horizontal, 16)
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .frame(height: 180)
            
            // Page Indicator
            HStack(spacing: 6) {
                ForEach(0..<BannerModel.mockList.count, id: \.self) { index in
                    Circle()
                        .fill(
                            index == currentBannerPage ? Color.primary : Color.gray
                                .opacity(0.3)
                        )
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 22)
        }
    }
    
    // MARK: - Category Section
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            Text("Categories")
                .font(.headlineLarge)
                .foregroundColor(.textPrimary)
                .padding(.horizontal, Spacing.screenPadding)
               
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(viewModel.categories) { category in
                        CategoryCard(
                            icon: category.icon,
                            title: category.name,
                            isSelected: selectedCategory == category.name,
                            action: {
                                selectedCategory = category.name
                            }
                        )
                    }
                }
                .padding(.horizontal, Spacing.xs)
            }
        }
    }
       
    // MARK: - Food Section
    private var foodSection: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            HStack {
                Text("Popular Foods")
                    .font(.headlineLarge)
                    .foregroundColor(.textPrimary)
                   
                Spacer()
                   
                Button(action: {}) {
                    Text("See All")
                        .font(.labelMedium)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, Spacing.screenPadding)
               
            VStack(spacing: Spacing.sm) {
                ForEach(viewModel.displayedFoods) { food in
                    FoodCard(food: food) {
                        router.navigate(to: .foodDetail(food))
                    }
                }
            }
            .padding(.horizontal, Spacing.screenPadding)
        }
    }
    
    private func errorView(message: String) -> some View {
           VStack(spacing: Spacing.md) {
               Image(systemName: "exclamationmark.triangle")
                   .font(.system(size: 50))
                   .foregroundColor(.error)
               
               Text("Oops!")
                   .font(.headlineLarge)
                   .foregroundColor(.textPrimary)
               
               Text(message)
                   .font(.bodyMedium)
                   .foregroundColor(.textSecondary)
                   .multilineTextAlignment(.center)
                   .padding(.horizontal, Spacing.xl)
               
               Button(action: {
                   Task {
                       await viewModel.fetchHomeData()
                   }
               }) {
                   Text("Try Again")
                       .font(.headlineSmall)
                       .foregroundColor(.white)
                       .padding(.horizontal, Spacing.xl)
                       .padding(.vertical, Spacing.md)
                       .background(Color.primary)
                       .cornerRadius(Spacing.radiusMedium)
               }
           }
           .padding(.top, 50)
       }
    
    private func errorOverlay(message: String) -> some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: Spacing.md) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 50))
                    .foregroundColor(.error)
                
                Text("Oops!")
                    .font(.headlineLarge)
                    .foregroundColor(.textPrimary)
                
                Text(message)
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
                
                Button(action: {
                    Task {
                        await viewModel.fetchHomeData()
                    }
                }) {
                    Text("Try Again")
                        .font(.headlineSmall)
                        .foregroundColor(.white)
                        .padding(.horizontal, Spacing.xl)
                        .padding(.vertical, Spacing.md)
                        .background(Color.primary)
                        .cornerRadius(Spacing.radiusMedium)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(Spacing.radiusLarge)
            .shadow(radius: 10)
            .padding(Spacing.xl)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(Router())
}

