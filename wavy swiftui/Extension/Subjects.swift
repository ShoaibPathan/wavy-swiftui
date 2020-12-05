//
//  Subjects.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 04/12/2020.
//

import Combine

extension Just {
    static func withErrorType<E>(_ value: Output, _ errorType: E.Type) -> AnyPublisher<Output, E> {
        Just(value)
            .setFailureType(to: errorType)
            .eraseToAnyPublisher()
    }
}
