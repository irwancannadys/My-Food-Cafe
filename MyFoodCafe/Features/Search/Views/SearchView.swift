//
//  SearchView.swift
//  MyFoodCafe
//
//  Created by irwan on 19/12/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                Text("Search")
                    .font(.displayLarge)
                
                PrimaryButton(title: "Test Navigation") {
                    router.navigate(to: .cart)
                }
                .padding(.horizontal)
            }
        }
    }
}
