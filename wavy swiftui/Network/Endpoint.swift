//
//  Endpoint.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 06/12/2020.
//

import Foundation

struct Endpoint {
    var path: String = ""
    var configuration = Configuration()

    func makeRequest(for host: String) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = configuration.scheme
        components.host = host
        components.path = path
        components.queryItems = configuration.query?.map { (k, v) in URLQueryItem(name: k, value: v) } ?? []

        if case let .url(key, value) = configuration.authentication {
            components.queryItems!.append(URLQueryItem(name: key, value: value))
        }

        guard let url = components.url?.absoluteURL else {
            throw ApiError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = configuration.method.rawValue
        request.httpBody = try configuration.body?()
        request.allHTTPHeaderFields = configuration.headers
        if case let .bearer(token) = configuration.authentication {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    func makeAssetRequest(for baseURL: String) throws -> URLRequest {
        guard let url = URL(string: baseURL) else {
            throw ApiError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = configuration.method.rawValue
        request.allHTTPHeaderFields = configuration.headers
        if case let .bearer(token) = configuration.authentication {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}

extension Endpoint {
    enum Authentication {
        case none
        case bearer(token: String)
        case url(key: String, value: String)
    }
}

extension Endpoint {
    struct Configuration {
        var scheme: String = "https"

        var method: HTTPMethod = .get
        var authentication: Authentication = .none

        var headers: [String: String] = [:]
        var query: [String: String]?

        var body: HTTPBody?
    }
}

extension Endpoint.Configuration {
    func set<T>(_ value: T, keyPath: WritableKeyPath<Self, T>) -> Self {
        var res = self
        res[keyPath: keyPath] = value
        return res
    }
}
