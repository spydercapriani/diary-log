//
//  Codable+.swift
//  
//
//  Created by Danny Gilbert on 1/20/22.
//

public struct AnyKey: CodingKey, ExpressibleByStringLiteral {
    public typealias StringLiteralType = String
    
    public var intValue: Int? { nil }
    public init?(intValue: Int) { nil }
    
    public let stringValue: String
    public init(stringLiteral stringValue: String) {
        self.stringValue = stringValue
    }
    
    public init(stringValue: String) {
        self.stringValue = stringValue
    }
}

public struct AnyEncodable: Encodable {
    
    private let encodable: Encodable
    
    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try encodable.encode(to: &container)
    }
    
    public static func encoded(_ any: Any?) -> AnyEncodable? {
        guard let any = Helpers.unwrap(any) else {
            return AnyEncodable(AnyEncodable?.none)
        }

        switch any {
        case let codable as Encodable:
            return AnyEncodable(codable)
            
        case let array as [Any?]:
            var elements: [AnyEncodable] = []
            
            for element in array {
                guard let encodable = encoded(element) else { return nil }
                elements.append(encodable)
            }
            
            return AnyEncodable(elements)
        case let dictionary as [String: Any?]:
            var dict: [String: AnyEncodable] = [:]
            
            for (k, v) in dictionary {
                guard let encodable = encoded(v) else { continue }
                dict[k] = encodable
            }
            
            return AnyEncodable(dict)
            
        default: return nil
        }
    }
}

public extension Encodable {
    
    func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}
