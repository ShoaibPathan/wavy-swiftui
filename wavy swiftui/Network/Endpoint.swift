//
//  Endpoint.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 06/12/2020.
//

import Foundation

struct Endpoint {
    var path: String = ""
    var method: HTTPMethod = .get
    var authentication: Authentication = .none
    var query: [String: String] = [:]
    var headers: [String: String] = [:]
    var body: HTTPBody?

    func makeRequest(for baseURL: String) throws -> URLRequest {
        guard let url = makeURL(base: baseURL) else {
            throw ApiError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if case let .bearer(token) = authentication {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try body?()

        return request
    }

    private func makeQueryString() -> String? {
        if query.isEmpty {
            return nil
        }

        var params: [String] = []
        for (key, value) in query {
            guard let paramKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let paramValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return nil
            }
            params.append("\(paramKey)=\(paramValue)")
        }
        return params.joined(separator: "&")
    }

    private func makeURL(base: String) -> URL? {
        var url = base.appending(path)
        if let params = makeQueryString() {
            url.append("?\(params)")
        }
        if case let .url(key, value) = authentication {
            url.append("&\(key)=\(value)")
        }

        return URL(string: url)
    }
}

extension Endpoint {
    enum Authentication {
        case none
        case bearer(token: String)
        case url(key: String, value: String)
    }
}
