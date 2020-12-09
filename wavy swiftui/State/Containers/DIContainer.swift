//
//  DIContainer.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Foundation
import SwiftUI

struct DIContainer: EnvironmentKey {
    let state: Store<AppState>
    let interactors: InteractorsContainer

    static var defaultValue: Self { Self.default }
    private static let `default` = Self(
        state: Store(AppState()),
        interactors: .stub
    )
}

extension EnvironmentValues {
    var container: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

// MARK: - Containers
extension DIContainer {
    // MARK: - App interactors
    struct InteractorsContainer {
        let quotes: PQuotesInteractor
        let wallpapers: PWallpapersInteractor

        static var stub: Self {
            .init(
                quotes: StubQuotesInteractor(),
                wallpapers: StubWallpapersInteractor()
            )
        }
    }

    // MARK: - Remote data
    struct NetworkContainer {
        let quotesAgent: PQuotesAgent
        let wallpapersAgent: PWallpapersAgent
    }

    // MARK: - Local persisted data
    struct RepositoriesContainer {
        let quotes: PQuotesRepository
    }
}
