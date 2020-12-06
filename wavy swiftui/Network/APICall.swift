//
//  APICall.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Foundation

//protocol APICall {
//    var path: String { get }
//    var method: HTTPMethod { get }
//    var headers: [String: String] { get }
//    func body() throws -> Data?
//}
//
//extension APICall {
//    func buildRequest(for baseUrl: String) throws -> URLRequest {
//        guard let url = URL(string: baseUrl.appending(path)) else {
//            throw ApiError.invalidURL
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        request.allHTTPHeaderFields = headers
//        request.httpBody = try body()
//
//        return request
//    }
//}
