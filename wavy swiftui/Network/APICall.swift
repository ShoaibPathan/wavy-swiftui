//
//  APICall.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Foundation

struct CallOptions: OptionSet {
    var rawValue: Int

    static let withAuth = CallOptions(rawValue: 1)
    static let json = CallOptions(rawValue: 1 << 1)

    static let all: [CallOptions] = [.withAuth, .json]
}

typealias HTTPBody = () throws -> Data?

protocol APICall {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    func body() throws -> Data?
}

extension APICall {
    func buildRequest(for baseUrl: String) throws -> URLRequest {
        guard let url = URL(string: baseUrl.appending(path)) else {
            throw ApiError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = try body()

        return request
    }
}

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

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
