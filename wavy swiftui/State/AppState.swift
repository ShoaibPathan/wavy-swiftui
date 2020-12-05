//
//  AppState.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Foundation
import SwiftUI

struct AppState: Equatable {
    var data = AppData()
    var router = Router()

    static func == (lhs: AppState, rhs: AppState) -> Bool {
        lhs.data == rhs.data &&
            lhs.router == rhs.router
    }
}

// MARK: - User data
extension AppState {
    struct AppData: Equatable {
        var quote: Quote?
        var token: String = ""
    }
}

// MARK: - Router
extension AppState {
    struct Router: Equatable {
        var home = HomeView.Router()
    }
}

// MARK: - Router protocols used for Views
protocol ViewRouter: Equatable {
    associatedtype Sheet

    var sheet: Sheet? { get set }
}

protocol SheetBuilder: Identifiable, Equatable {
    associatedtype Content

    var id: String { get }
    func makeSheet() -> Content
}
