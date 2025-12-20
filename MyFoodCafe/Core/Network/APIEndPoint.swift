//
//  APIEndPoint.swift
//  MyFoodCafe
//
//  Created by irwan on 20/12/25.
//

import Foundation

enum APIEndpoint {
    static let baseURL = "https://private-18fc4d-myfoodcafe.apiary-mock.com"
    
    case foods
    case foodDetail(id: String)
    case categories
    case banners
    
    var path: String {
        switch self {
        case .foods:
            return "/api/foods"
        case .foodDetail(let id):
            return "/api/foods/\(id)"
        case .categories:
            return "/api/categories"
        case .banners:
            return "/api/banners"
        }
    }
    
    var url: URL? {
        return URL(string: APIEndpoint.baseURL + path)
    }
}

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case cancelled
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .cancelled:
            return "Request cancelled"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}
