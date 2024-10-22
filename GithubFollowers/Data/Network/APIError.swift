//
//  ApiError.swift
//  TestApp
//
//  Created by Kiet Truong on 13/09/2024.
//

import Foundation

struct APIErrorParams {
  let statusCode: Int
  let message: String
}

enum APIError: Error {
    case invalidPath
    case decoding
    case invalidResponse
    case clientError(APIErrorParams) // 4xx
    case serverError(APIErrorParams) // 5xx
}

extension APIError {
    
    var description: String {
        switch self {
        case .invalidPath:
            return "Invalid Path"
        case .decoding:
            return "There was an error decoding the type"
        case .invalidResponse:
            return "Invalid response from server"
        case .clientError(let params):
            return "\(params.statusCode) - \(params.message)"
        case .serverError(let params):
            return "\(params.statusCode) - \(params.message)"
        }
    }
}
