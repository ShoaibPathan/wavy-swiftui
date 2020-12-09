//
//  QuotesRepository.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 03/12/2020.
//

import Combine
import Foundation

protocol PQuotesRepository {
    func hasQuotes() -> AnyPublisher<Quote?, Error>
    func setQuote(to quote: Quote)
}

struct QuotesRepository: PQuotesRepository {
    let appState: Store<AppState>

    func hasQuotes() -> AnyPublisher<Quote?, Error> {
        Just
            .withErrorType(appState[\.data.quote], Error.self)
    }

    func setQuote(to quote: Quote) {
        appState[\.data.quote] = quote
    }
}
