//
//  Character.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 8/11/21.
//

import Foundation

// MARK: - Result
struct Character: Codable {
    let id: Int
    let name, resultDescription: String
    let modified: String?
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics, series: Comics
    let stories: Stories
    let events: Comics
    let urls: [URLElement]

    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case modified, thumbnail, resourceURI, comics, series, stories, events, urls
    }
}

// MARK: - Comics
struct Comics: Codable {
    let available: Int
    let collectionURI: String
    let items: [ComicsItem]
    let returned: Int
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Stories
struct Stories: Codable {
    let available: Int
    let collectionURI: String
    let items: [StoriesItem]
    let returned: Int
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    let resourceURI: String
    let name: String
}

enum ItemType: String, Codable {
    case cover = "cover"
    case empty = ""
    case interiorStory = "interiorStory"
    case pinup = "pinup"
    case profile = "profile"
    case recap = "recap"
    case ad = "ad"
    case backcovers = "backcovers"
    case textArticle = "text article"
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    var path: String
    var thumbnailExtension: Extension
    var imageUrl: URL? {
        .init(string: "\(self.path).\(self.thumbnailExtension)")
    }
    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
    
    init () {
        path = ""
        thumbnailExtension = (.init(rawValue: "") ?? .gif)
    }
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.thumbnailExtension = try container.decodeIfPresent(Extension.self, forKey: .thumbnailExtension) ?? (.init(rawValue: "") ?? .png)
            self.path = try container.decodeIfPresent(String.self, forKey: .path) ?? ""
        }
        catch let error {
            path = ""
            thumbnailExtension = (.init(rawValue: "") ?? .gif)
            print("error parsing user: \(error.localizedDescription)")
        }
    }
    
}

enum Extension: String, Codable {
    case jpg = "jpg"
    case gif = "gif"
    case png = "png"
    
    
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: URLType
    let url: String
}

enum URLType: String, Codable {
    case comiclink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
}
