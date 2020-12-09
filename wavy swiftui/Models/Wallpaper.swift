//
//  Wallpaper.swift
//  wavy swiftui
//
//  Created by Tom Rochat on 06/12/2020.
//

import Foundation

struct Wallpaper: Identifiable, Codable {
    let id: String

    let width: Int
    let height: Int

    let path: String
    let thumbs: Thumbs
}

extension Wallpaper {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "dimension_x"
        case height = "dimension_y"
        case path = "path"
        case thumbs = "thumbs"
    }
}

struct Thumbs: Codable {
    let original: String
}
