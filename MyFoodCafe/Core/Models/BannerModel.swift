//
//  BannerModel.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import Foundation

struct BannerModel: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let imageUrl: String
    let actionType: String
    let actionValue: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, subtitle
        case imageUrl = "image_url"
        case actionType = "action_type"
        case actionValue = "action_value"
    }
}

// MARK: - Mock Data
extension BannerModel {
    static let mockList: [BannerModel] = [
        BannerModel(id: "banner_001", title: "Free Delivery", subtitle: "For orders above Rp 50.000", imageUrl: "https://picsum.photos/400/200?random=10", actionType: "none", actionValue: nil),
        BannerModel(id: "banner_002", title: "50% Off", subtitle: "On your first order", imageUrl: "https://picsum.photos/400/200?random=11", actionType: "promo", actionValue: "FIRST50"),
        BannerModel(id: "banner_003", title: "New Restaurant", subtitle: "Explore our newest partners", imageUrl: "https://picsum.photos/400/200?random=12", actionType: "restaurant", actionValue: "rest_999"),
    ]
}
