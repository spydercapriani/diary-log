//
//  Entry+Context.swift
//  
//
//  Created by Danny Gilbert on 1/20/22.
//

extension Entry {
    
    public struct Metadata {
        var metadata: [AnyHashable: Any]
    }
}

// MARK: - Initializers
extension Entry.Metadata: ExpressibleByDictionaryLiteral {
    
    public init(
        _ metadata: [AnyHashable: Any]
    ) {
        self.metadata = metadata
    }
    
    public init?(
        _ metadata: Logger.Metadata?
    ) {
        guard let metadata = metadata else { return nil }
        self.metadata = metadata.reduce(into: [:]) { result, metadata in
            let (key, value) = metadata
            result[key] = Helpers.convert(value)
        }
    }
    
    public init(dictionaryLiteral elements: (AnyHashable, Any)...) {
        self.init(
            metadata: elements.reduce(into: [:]) { $0[$1.0] = $1.1 }
        )
    }
}

// MARK: - Subscript
public extension Entry.Metadata {
    
    subscript<C: Context>(_ key: C.Type) -> C?        {
        get { metadata[key.key] as? C }
        set { metadata[key.key] = newValue }
    }

    subscript(_ key: AnyHashable) -> Any? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }
}

// MARK: - Encodable
extension Entry.Metadata: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AnyKey.self)
        for (k, v) in metadata {
            guard
                let key = k.base as? String,
                let encodable = AnyEncodable.encoded(v)
            else {
                continue
            }
            try container.encode(encodable, forKey: .init(stringValue: key))
        }
    }
}

// MARK: - Details
public extension Entry.Metadata {
    
    var prettyMetadata: String? {
        let pretty = metadata
            .compactMap { "\t--\($0)=\($1)" }
            .joined(separator: "\n")
        guard !pretty.isEmpty else { return nil }
        return pretty
    }
}
