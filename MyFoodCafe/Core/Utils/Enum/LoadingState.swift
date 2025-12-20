//
//  LoadingState.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//


// MARK: - UI State
enum LoadingState: Equatable {
    case idle
    case loading
    case success
    case failure(String)
}
