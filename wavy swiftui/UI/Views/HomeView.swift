//
//  HomeView.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Combine
import SwiftUI

struct HomeView: View {
    @State private var sheet: Sheet?
    private var showSheetUpdates: AnyPublisher<Sheet?, Never> {
        container.state.updates(for: \.router.home.sheet)
    }

    @State private var quote: Loadable<Quote> = .notRequested
    @State private var lastQuote: Quote?
    @State private var image: Loadable<Image> = .notRequested

    @Environment(\.container) private var container
    var body: some View {
        VStack {
            Group {
                switch image {
                case .notRequested: EmptyView()
                case .loading(_, _): ProgressView().progressViewStyle(CircularProgressViewStyle())
                case let .loaded(networkImage): networkImage.resizable().frame(maxWidth: 200, maxHeight: 200)
                case let .failed(error): Text("Failed to load image: \(error.localizedDescription)").foregroundColor(.red)
                }
            }
            .padding(.top)
            Spacer()

            switch quote {
            case .notRequested: Text("No quote requested")
            case let .loading(last, _): Text("Loading...").onAppear { lastQuote = last }
            case let .loaded(value): Text("\(value.quote)").padding()
            case let .failed(error): Text("Failed with error: \(error.localizedDescription)")
            }
            Spacer()

            HStack {
                Button("Fetch a quote") {
                    container.interactors.quotes.loadQuote(data: $quote)
                }

                Button("Show latest quote") {
                    openSheet(.lastQuote(lastQuote?.quote ?? ""))
                }
            }
        }
        .sheet(item: $sheet, onDismiss: {
            closeSheet()
        }, content: {
            $0.makeSheet()
        })
        .onAppear { container.interactors.quotes.image(data: $image) }
        .onReceive(showSheetUpdates) { sheet = $0 }
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
