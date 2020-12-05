//
//  Store.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Combine
import Foundation

// Output -> The output type of the subject
// Failure -> The error type of the subject
// value -> The current value of our subject

typealias Store<T> = CurrentValueSubject<T, Never>

extension Store {
    subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
        get { value[keyPath: keyPath] }
        set {
            var value = self.value
            if value[keyPath: keyPath] != newValue {
                value[keyPath: keyPath] = newValue
                self.value = value
            }
        }
    }

    func updates<T>(for keyPath: KeyPath<Output, T>) -> AnyPublisher<T, Failure> where T: Equatable {
        map(keyPath).removeDuplicates().eraseToAnyPublisher()
    }
}
