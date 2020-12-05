//
//  wavy_swiftuiApp.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import SwiftUI

@main
struct wavy_swiftuiApp: App {
    private let appEnvironment: AppEnvironment

    init() {
        appEnvironment = AppEnvironment.spawn()
    }

    var body: some Scene {
        WindowGroup {
            content
        }
    }

    private var content: some View {
        Group {
            if ProcessInfo.processInfo.isRunningTests {
                Text("Running tests...")
            } else {
                ContentView()
                    .environment(\.container, appEnvironment.container)
            }
        }
    }
}
