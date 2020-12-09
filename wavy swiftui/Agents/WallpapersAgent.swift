//
//  WallpapersAgent.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 06/12/2020.
//

import Combine
import Foundation
import SwiftUI

protocol PWallpapersAgent: NetworkAgent {
    func loadWallpapers(page: Int) -> AnyPublisher<APIFormat, Error>
    func loadImage(from url: String) -> AnyPublisher<Image, Error>
}

struct APIFormat: Codable {
    let data: [Wallpaper]
}

struct WallpapersAgent: PWallpapersAgent {
    let state: Store<AppState>
    let host: String
    let session: URLSession
    let bgQueue = DispatchQueue(label: "background-parsing-queue")

    func loadWallpapers(page: Int) -> AnyPublisher<APIFormat, Error> {
        var endpoint = Endpoint(path: API.search.path, configuration: .init())
        endpoint.configuration = endpoint.configuration
            .set(.url(key: "apikey", value: ""), keyPath: \.authentication)
            .set([
                "page": String(page),
            ], keyPath: \.query)

        return call(endpoint: endpoint)
    }

    func loadImage(from url: String) -> AnyPublisher<Image, Error> {
        let endpoint = Endpoint()

        return image(from: url, endpoint: endpoint)
    }
}

extension WallpapersAgent {
    enum API {
        case search

        var prefix: String { "/api/v1" }
        var path: String {
            switch self {
            case .search: return "\(prefix)/search"
            }
        }
    }
}
