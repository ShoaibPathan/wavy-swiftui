//
//  Loadable.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 03/12/2020.
//

import Combine
import SwiftUI

typealias LoadableSubject<T> = Binding<Loadable<T>>

enum Loadable<T> {
    case notRequested
    case loading(last: T?, store: CancelBag)
    case loaded(T, store: CancelBag?)
    case failed(Error)

    var value: T? {
        switch self {
        case let .loaded(value, _): return value
        case let .loading(last, _): return last
        default: return nil
        }
    }

    var error: Error? {
        switch self {
        case let .failed(err): return err
        default: return nil
        }
    }

    mutating func setLoading(store: CancelBag) {
        self = .loading(last: value, store: store)
    }

    mutating func setLoaded(value: T) {
        self = .loaded(value, store: nil)
    }

    mutating func setFailed(error: Error) {
        self = .failed(error)
    }

    mutating func cancelLoading() {
        if case let .loading(value, store) = self {
            store.cancel()
            if let lastValue = value {
                self = .loaded(lastValue, store: nil)
            } else {
                self = .failed(ApiError.cancelledByUser)
            }
        }
    }
}

final class CancelBag {
    var subs = Set<AnyCancellable>()

    func cancel() {
        subs.forEach { $0.cancel() }
        subs.removeAll()
    }
}

extension AnyCancellable {
    func store(in bag: CancelBag) {
        bag.subs.insert(self)
    }
}
