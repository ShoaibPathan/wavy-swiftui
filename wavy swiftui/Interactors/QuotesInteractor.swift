//
//  QuotesInteractor.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Combine
import SwiftUI

protocol PQuotesInteractor {
    func loadQuote(data: LoadableSubject<Quote>)
    func image(data: LoadableSubject<Image>)
}

struct QuotesInteractor: PQuotesInteractor {
    let state: Store<AppState>
    let agent: PQuotesAgent
    let repository: PQuotesRepository

    func loadQuote(data: LoadableSubject<Quote>) {
        let store = CancelBag()
        data.wrappedValue.setLoading(store: store)

        Just
            .withErrorType((), Error.self)
//            .flatMap { [repository] in
//                return repository.hasQuotes()
//            }
//            .flatMap { quote -> AnyPublisher<Quote, Error> in
//                if let quote = quote {
//                    print("fetched from db")
//                    return Just.withErrorType(quote, Error.self)
//                } else {
//                    print("fetched from api")
//                    return fetchQuote()
//                }
//            }
            .flatMap { _ in
                fetchQuote()
            }
            .sink { subCompletion in
                if case let .failure(error) = subCompletion {
                    data.wrappedValue.setFailed(error: error)
                }
            } receiveValue: {
                data.wrappedValue.setLoaded(value: $0)
            }
            .store(in: store)
    }

    func image(data: LoadableSubject<Image>) {
        let store = CancelBag()
        data.wrappedValue.setLoading(store: store)

        agent.loadImage(from: "https://raw.githubusercontent.com/tomrcht/wavy-swift/master/Wavyswift/Assets.xcassets/kanye-smile.imageset/kanye-smile.png")
            .sink { subCompletion in
                if case let .failure(error)  = subCompletion {
                    data.wrappedValue.setFailed(error: error)
                }
            } receiveValue: {
                data.wrappedValue.setLoaded(value: $0)
            }
            .store(in: store)
    }

    func fetchQuote() -> AnyPublisher<Quote, Error> {
        agent.loadQuote()
            .flatMap { [repository] quote -> AnyPublisher<Quote, Error> in
                repository.setQuote(to: quote)
                return Just(quote).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

struct StubQuotesInteractor: PQuotesInteractor {
    func loadQuote(data: LoadableSubject<Quote>) { }
    func image(data: LoadableSubject<Image>) { }
}
