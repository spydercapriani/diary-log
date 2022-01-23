//
//  Codable+.swift
//  
//
//  Created by Danny Gilbert on 1/20/22.
//

struct AnyKey: CodingKey, ExpressibleByStringLiteral {
    typealias StringLiteralType = String
    
    var intValue: Int? { nil }
    init?(intValue: Int) { nil }
    
    let stringValue: String
    init(stringLiteral stringValue: String) {
        self.stringValue = stringValue
    }
    
    init(stringValue: String) {
        self.stringValue = stringValue
    }
}

struct AnyEncodable: Encodable {
    
    private let encodable: Encodable
    
    init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try encodable.encode(to: &container)
    }
}

extension Encodable {
    
    func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}
