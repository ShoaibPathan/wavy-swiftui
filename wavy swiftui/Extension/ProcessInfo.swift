//
//  ProcessInfo.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 02/12/2020.
//

import Foundation

extension ProcessInfo {
    var isRunningTests: Bool { environment["XCTestConfigurationFilePath"] != nil }
}
