//
//  PaginatedCharacters.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 8/11/21.
//

import Foundation
// MARK: - PaginatedCharacters
class PaginatedCharacters: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [Character]
    
    public init() {
        offset = 0
        limit = 0
        total = 0
        count = 0
        results = []
    }
}
