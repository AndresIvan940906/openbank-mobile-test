//
//  JsonLoader.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 11/11/21.
//

import Foundation

/// Must match the JSON file names added to Unit Test and UI Tests target.
public enum JsonNamed: String {
    case characterList = "CharacterResponse"
}

public class JsonLoader {
    public static func dictionary(for json: JsonNamed) -> [String: Any] {
        let data = self.data(for: json)

        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            assertionFailure("Couldn't retrieved data from json file: \(json.rawValue)")
            return [:]
        }

        return jsonData
    }

    public static func data(for json: JsonNamed) -> Data {

        let identifier = "Andres-Marin.Openbank-Mobile-Test"
        

        guard let filePath = Bundle(identifier: identifier)?.path(forResource: json.rawValue, ofType: "json") else {
            assertionFailure("Couldn't find a json file named: \(json.rawValue)")
                return Data()
        }

        let url = URL(fileURLWithPath: filePath)

        guard let data = try? Data(contentsOf: url) else {
            assertionFailure("Couldn't retrieved data from json file: \(json.rawValue)")
            return Data()
        }

        return data
    }
}

class DictionaryDecoder {

    private let decoder = JSONDecoder()

    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        set { decoder.dateDecodingStrategy = newValue }
        get { return decoder.dateDecodingStrategy }
    }

    var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        set { decoder.dataDecodingStrategy = newValue }
        get { return decoder.dataDecodingStrategy }
    }

    var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        set { decoder.nonConformingFloatDecodingStrategy = newValue }
        get { return decoder.nonConformingFloatDecodingStrategy }
    }

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        set { decoder.keyDecodingStrategy = newValue }
        get { return decoder.keyDecodingStrategy }
    }

    func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decoder.decode(type, from: data)
    }
}
