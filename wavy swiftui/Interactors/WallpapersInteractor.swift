//
//  WallpapersInteractor.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 06/12/2020.
//

import Combine
import SwiftUI

protocol PWallpapersInteractor {
    func load(data: LoadableSubject<[Wallpaper]>, page: Int)
}

struct WallpapersInteractor: PWallpapersInteractor {
    let state: Store<AppState>
    let agent: PWallpapersAgent

    func load(data: LoadableSubject<[Wallpaper]>, page: Int) {
        let store = CancelBag()
        data.wrappedValue.setLoading(store: store)

        Just.withErrorType((), Error.self)
            .flatMap { _ in
                agent.loadWallpapers(page: page)
            }
            .map { response in
                response.data
            }
            .sink { subCompletion in
                if case let .failure(error) = subCompletion {
                    data.wrappedValue.setFailed(error: error)
                }
            } receiveValue: {
                if var currentWallpapers = data.wrappedValue.value {
                    currentWallpapers.append(contentsOf: $0)
                    data.wrappedValue.setLoaded(value: currentWallpapers)
                } else {
                    data.wrappedValue.setLoaded(value: $0)
                }
            }
            .store(in: store)
    }
}

struct StubWallpapersInteractor: PWallpapersInteractor {
    func load(data: LoadableSubject<[Wallpaper]>, page: Int) { }
}
