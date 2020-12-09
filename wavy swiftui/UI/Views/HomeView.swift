//
//  HomeView.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Combine
import SwiftUI
import KingfisherSwiftUI
import URLImage

struct HomeView: View {
    @State private var wallpapers: Loadable<[Wallpaper]> = .notRequested
    @State private var currentPage = 1

    @Environment(\.container) private var container
    var body: some View {
        content
    }

    var content: some View {
        VStack {
            wallpapersList(data: wallpapers.value ?? [])
                .onAppear { loadWallpapers() }

            HStack(spacing: 10) {
                Text("Page: \(currentPage)")
                Text("\(wallpapers.value?.count ?? 0) walls")
                Spacer()
                if case .loading(_, _) = wallpapers {
                    Text("Loading...")
                }
                Button("Next") {
                    currentPage += 1
                    loadWallpapers()
                }
            }.padding(.horizontal)
        }
    }

    private func wallpapersList(data: [Wallpaper]) -> some View {
        ScrollView {
            LazyVStack(spacing: 5) {
                ForEach(data) { w in
                    networkImage(url: w.thumbs.original)
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .onAppear {
                            loadNextPage(current: w.id)
                        }

//                    URLImage(url: URL(string: w.thumbs.original)!) { _ in
//                        RoundedRectangle(cornerRadius: 8.0)
//                            .fill(Color.pink)
//                            .frame(height: 300)
//                    } failure: { (err, _) in
//                        Text(err.localizedDescription).foregroundColor(.red)
//                    } content: { image in
//                        image
//                            .resizable()
//                            .scaledToFit()
//                    }
                }
            }
        }
    }

    private func networkImage(url: String) -> some View {
        KFImage(URL(string: url))
            .resizable()
            .placeholder { ProgressView().progressViewStyle(CircularProgressViewStyle()) }
            .cancelOnDisappear(true)
    }

    private func loadWallpapers() {
        container.interactors.wallpapers.load(data: $wallpapers, page: currentPage)
    }

    private func loadNextPage(current: String) {
        guard let walls = wallpapers.value else {
            return
        }

         let thresholdIndex = walls.index(walls.endIndex, offsetBy: -10)
        let currentIndex = walls.firstIndex { $0.id == current }
        if currentIndex == thresholdIndex {
            currentPage += 1
            loadWallpapers()
        }
    }
}

extension HomeView {
    struct Router: ViewRouter {
        var sheet: Sheet?
    }

    enum Sheet: SheetBuilder {
        case lastQuote(String)

        var id: String {
            switch self {
            case .lastQuote: return "last-quote"
            }
        }

        func makeSheet() -> some View {
            NavigationView {
                switch self {
                 case let .lastQuote(quoteString): Text(quoteString).foregroundColor(.gray)
                }
            }
        }
    }
}

private extension HomeView {
    func openSheet(_ sheet: Sheet) {
        container.state[\.router.home.sheet] = sheet
    }

    func closeSheet() {
        container.state[\.router.home.sheet] = nil
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
