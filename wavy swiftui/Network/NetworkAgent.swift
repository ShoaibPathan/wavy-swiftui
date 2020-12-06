//
//  NetworkAgent.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Combine
import SwiftUI
import UIKit

protocol NetworkAgent {
    var baseURL: String { get }
    var session: URLSession { get }
    var bgQueue: DispatchQueue { get }
}

extension NetworkAgent {
    func call<T>(endpoint: Endpoint) -> AnyPublisher<T, Error> where T: Decodable {
        do {
            let request = try endpoint.makeRequest(for: baseURL)

            return session
                .dataTaskPublisher(for: request)
                .receive(on: DispatchQueue.main)
                .tryMap { response in
                    guard let code = (response.response as? HTTPURLResponse)?.statusCode else {
                        throw ApiError.invalidResponse
                    }
                    guard 200...299 ~= code else {
                        throw ApiError.httpCode(code)
                    }

                    return response.data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } catch let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func image(from baseURL: String, endpoint: Endpoint) -> AnyPublisher<Image, Error> {
        do {
            let request = try endpoint.makeRequest(for: baseURL)

            return session
                .dataTaskPublisher(for: request)
                .subscribe(on: bgQueue)
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) in
                    guard let image = UIImage(data: data) else {
                        throw ApiError.invalidResponse
                    }
                    return Image(uiImage: image)
                }
                .eraseToAnyPublisher()
        } catch let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
