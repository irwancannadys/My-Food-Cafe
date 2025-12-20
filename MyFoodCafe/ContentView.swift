//
//  ContentView.swift
//  MyFoodCafe
//
//  Created by irwan on 19/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)
            
            OrderView()
                .tabItem {
                    Label("Order", systemImage: "list.bullet.clipboard")
                }
                .tag(Tab.order)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .tint(.primaryDark)  // Tab selected color
    }
}

enum Tab {
    case home
    case search
    case order
    case profile
}

#Preview {
    ContentView()
}
