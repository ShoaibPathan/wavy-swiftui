//
//  APIError.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 06/12/2020.
//

import Foundation

enum ApiError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case cancelledByUser
    case httpCode(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .cancelledByUser: return "User cancelled the request"
        case let .httpCode(code): return "HTTP error: code \(code)"
        }
    }
}
