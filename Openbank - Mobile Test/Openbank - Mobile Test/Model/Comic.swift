//
//  Comic.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 9/11/21.
//

import Foundation


struct ComicResult: Codable {
    let results: [Comic]
}
// MARK: - Result
struct Comic: Codable {
    let id: Int
    let title: String
    let variantDescription, resultDescription: String?
    let thumbnail: Thumbnail
    let characters: Characters
    let creators: Creators
    enum CodingKeys: String, CodingKey {
        case id
        case title, variantDescription
        case resultDescription = "description"
        case thumbnail, characters, creators
    }
    public init () {
        id = 0
        title = ""
        variantDescription = ""
        resultDescription = ""
        thumbnail = .init()
        characters = .init(available: 0, collectionURI: "", items: [], returned: 0)
        creators = .init(available: 0, collectionURI: "", items: [], returned: 0)
    }
}

// MARK: - Characters
struct Characters: Codable {
    let available: Int
    let collectionURI: String
    let items: [Series]
    let returned: Int
}

// MARK: - Series
struct Series: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Creators
struct Creators: Codable {
    let available: Int
    let collectionURI: String
    let items: [CreatorsItem]
    let returned: Int
}

// MARK: - CreatorsItem
struct CreatorsItem: Codable {
    let resourceURI: String
    let name, role: String
}

// MARK: - DateElement
struct DateElement: Codable {
    let type, date: String
}



// MARK: - Price
struct Price: Codable {
    let type: String
    let price: Double
}


enum TypeEnum: String, Codable {
    case empty = ""
    case interiorStory = "interiorStory"
    case textArticle = "text article"
}

// MARK: - TextObject
struct TextObject: Codable {
    let type, language, text: String
}


