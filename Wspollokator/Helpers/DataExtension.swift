//
//  DataExtension.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 08.01.22.
//

import Foundation

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
