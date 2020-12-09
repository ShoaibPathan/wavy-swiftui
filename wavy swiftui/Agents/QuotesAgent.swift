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
    let host: String
    let session: URLSession
    let bgQueue = DispatchQueue(label: "background-parsing-queue")

    func loadQuote() -> AnyPublisher<Quote, Error> {
        return call(endpoint: Endpoint(path: API.quote.rawValue))
    }

    func loadImage(from url: String) -> AnyPublisher<Image, Error> {
        let endpoint = Endpoint()
        return image(from: url, endpoint: endpoint)
    }
}

extension QuotesAgent {
    enum API: String {
        case quote = "/"
    }
}
