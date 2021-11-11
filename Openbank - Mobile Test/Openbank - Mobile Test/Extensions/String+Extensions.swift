//
//  String+Extension.swift
//  Openbank - Mobile Test
//
//  Created by Andrres Marin on 8/11/21.
//

import Foundation
import CryptoKit

extension String {
    var md5: String {
        let hash = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return hash.map {String(format: "%02x", $0)}
            .joined()
    }
}
