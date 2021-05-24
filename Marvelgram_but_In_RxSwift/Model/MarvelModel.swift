//
//  MarvelModel.swift
//  Marvelgram_but_In_RxSwift
//
//  Created by Дмитрий Жучков on 15.05.2021.
//

import Foundation

// MARK: - MarvelJSONElement
struct MarvelJSONElement: Codable {
    let id: Int
    let name, marvelJSONDescription: String
    let modified: String
    let thumbnail: Thumbnail

    enum CodingKeys: String, CodingKey {
        case id, name
        case marvelJSONDescription = "description"
        case modified, thumbnail
    }
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: Extension

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum Extension: String, Codable {
    case jpg = "jpg"
}

typealias MarvelJSON = MarvelJSONElement
