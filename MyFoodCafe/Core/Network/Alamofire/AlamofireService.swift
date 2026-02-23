//
//  AlamofireService.swift
//  MyFoodCafe
//
//  Created by irwan on 23/02/26.
//

import Foundation
import Alamofire

class AlamofireService {
    static let shared = AlamofireService()
    
    // AF sudah punya session manager built-in
    // kita bisa custom kalau mau (timeout, interceptor, dll)
    private let session: Session
    
    private init() {
        // Konfigurasi default — bisa ditambah interceptor/adapter nanti
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        self.session = Session(configuration: configuration)
    }
    
    /// Generic request — mirip dengan APIService.request() tapi pakai Alamofire
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        method: HTTPMethod = .get
    ) async throws -> T {
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        // withCheckedThrowingContinuation = jembatan antara
        // callback-style (Alamofire) ke async/await style
        return try await withCheckedThrowingContinuation { continuation in
            session
                .request(url, method: method)
                .validate(statusCode: 200...299)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                        
                    case .failure(let afError):
                        // Mapping AFError ke APIError kita sendiri
                        if afError.isExplicitlyCancelledError {
                            continuation.resume(throwing: APIError.cancelled)
                        } else if let statusCode = response.response?.statusCode {
                            continuation.resume(throwing: APIError.httpError(statusCode))
                        } else if afError.isResponseSerializationError {
                            continuation.resume(throwing: APIError.decodingError(afError))
                        } else {
                            continuation.resume(throwing: APIError.unknown(afError))
                        }
                    }
                }
        }
    }
}
