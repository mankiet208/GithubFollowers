//
//  ApiManager.swift
//  TestApp
//
//  Created by Kiet Truong on 13/09/2024.
//

import UIKit
import Combine

class APIManager {
        
    static let shared = APIManager()
    
    private init() {}
    
    private let baseURL = "https://api.github.com"
    
    func getData<D: Decodable>(from endpoint: APIEndpoint) -> AnyPublisher<D, Error> {
        guard let request = try? createRequest(from: endpoint) else {
            return Fail(error: APIError.invalidPath).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { (data, response) -> D in
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard (200..<300) ~=  urlResponse.statusCode else {
                    let errorParams = APIErrorParams(
                        statusCode: urlResponse.statusCode,
                        message: urlResponse.description
                    )
                    
                    switch urlResponse.statusCode {
                    case (400...499):
                        throw APIError.clientError(errorParams)
                    case (500...599):
                        throw APIError.serverError(errorParams)
                    default:
                        throw APIError.invalidResponse
                    }
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                return try decoder.decode(D.self, from: data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

private extension APIManager {
    
    func createRequest(from endpoint: APIEndpoint) throws -> URLRequest? {
        guard var url = URL(string: baseURL.appending(endpoint.path)) else {
            return nil
        }
        
        if let parameters = endpoint.parameters {
            url.append(queryItems: parameters)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
        return request
    }
}
