//
//  AppEnvironment.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Foundation

struct AppEnvironment {
    let container: DIContainer

    private init(container: DIContainer) {
        self.container = container
    }

    static func spawn() -> AppEnvironment {
        let state = Store(AppState())
        // Deep linking bullshit

        let networkContainer = makeNetworkContainer(state: state)
        let repositoriesContainer = makeRepositoriesContainer(state: state)
        let interactorsContainer = makeInteractorsContainer(
            state: state,
            repositories: repositoriesContainer,
            network: networkContainer
        )

        let injectedDIContainer = DIContainer(state: state, interactors: interactorsContainer)
        return AppEnvironment(container: injectedDIContainer)
    }

    private static func makeNetworkContainer(state: Store<AppState>) -> DIContainer.NetworkContainer {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.urlCache = .shared
        let session = URLSession(configuration: configuration)

        let quotes = QuotesAgent(state: state, host: "api.kanye.rest", session: session)
        let wallpapers = WallpapersAgent(state: state, host: "wallhaven.cc", session: session)

        return .init(quotesAgent: quotes, wallpapersAgent: wallpapers)
    }

    private static func makeRepositoriesContainer(state: Store<AppState>) -> DIContainer.RepositoriesContainer {
        .init(quotes: QuotesRepository(appState: state))
    }

    private static func makeInteractorsContainer(
        state: Store<AppState>,
        repositories: DIContainer.RepositoriesContainer,
        network: DIContainer.NetworkContainer
    ) -> DIContainer.InteractorsContainer {
        let quotes = QuotesInteractor(state: state, agent: network.quotesAgent, repository: repositories.quotes)
        let walls = WallpapersInteractor(state: state, agent: network.wallpapersAgent)

        return .init(quotes: quotes, wallpapers: walls)
    }
}
