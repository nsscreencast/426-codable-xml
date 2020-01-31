//
//  NestedArray.swift
//  CodableXML
//
//  Created by Ben Scheirman on 1/30/20.
//  Copyright © 2020 NSScreencast. All rights reserved.
//

import Foundation

protocol KeyProvider {
    static var key: String { get }
}

struct NestedArray<T : Codable, K : KeyProvider>: Codable {
    private struct DynamicCodingKey: CodingKey {
        var stringValue: String
        var intValue: Int?

        init(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            self.intValue = intValue
            stringValue = "\(intValue)"
        }
    }

    var value: [T]

    init(from decoder: Decoder) throws {
        let codingKey = DynamicCodingKey(stringValue: K.key)
        let container = try decoder.container(keyedBy: DynamicCodingKey.self)
        value = try container.decode([T].self, forKey: codingKey)
    }

    func encode(to encoder: Encoder) throws {
        let codingKey = DynamicCodingKey(stringValue: K.key)
        var container = encoder.container(keyedBy: DynamicCodingKey.self)
        try container.encode(value, forKey: codingKey)
    }
}
