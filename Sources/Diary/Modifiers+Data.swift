//
//  Modifiers+Data.swift
//  
//
//  Created by Danny Gilbert on 1/26/22.
//

import Foundation

public extension Modifiers {
    
    private static let jsonEncoder: JSONEncoder = {
       let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return encoder
    }()
    static let jsonData = base
        .encode(using: jsonEncoder)
        .eraseToAnyModifier()
}
