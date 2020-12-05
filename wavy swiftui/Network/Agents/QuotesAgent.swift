//
//  QuotesAgent.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Combine
import SwiftUI

protocol PQuotesAgent: NetworkAgent {
    func loadQuote() -> AnyPublisher<Quote, Error>
    func loadImage(from: String) -> AnyPublisher<Image, Error>
}

struct QuotesAgent: PQuotesAgent {
    let state: Store<AppState>
    let baseURL: String
    let session: URLSession
    let bgQueue = DispatchQueue(label: "background-parsing-queue")

    func loadQuote() -> AnyPublisher<Quote, Error> {
        call(endpoint: API.quote)
    }

    func loadImage(from url: String) -> AnyPublisher<Image, Error> {
        image(from: url, endpoint: API.image)
    }
}

extension QuotesAgent {
    enum API: APICall {
        case quote
        case image

        var path: String {
            switch self {
            case .quote: return ""
            case .image: return ""
            }
        }

        var method: HTTPMethod {
            .get
        }

        var headers: [String : String] {
            [:]
        }

        func body() throws -> Data? {
            nil
        }
    }
}
