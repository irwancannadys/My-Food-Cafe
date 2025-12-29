//
//  MyFoodCafeApp.swift
//  MyFoodCafe
//
//  Created by irwan on 19/12/25.
//

import SwiftUI

@main
struct MyFoodCafeApp: App {
    
    @StateObject private var router = Router()
    
    var body: some Scene {
          WindowGroup {
              NavigationStack(path: $router.path) {
                  ContentView()
                      .navigationDestination(for: Route.self) { route in
                          DestinationView.destinationView(for: route)
                      }
              }
              .environmentObject(router)
          }
      }
}
