//
//  HTTP.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 06/12/2020.
//

import Foundation

typealias HTTPBody = () throws -> Data?

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
