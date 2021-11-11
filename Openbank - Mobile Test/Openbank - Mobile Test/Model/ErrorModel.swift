//
//  ErrorModel.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 8/11/21.
//

import Foundation


struct ErrorModel:Codable{
    var code : Code?
    var message : String?
    var status : String?
}
enum Code: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Code.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Code"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
