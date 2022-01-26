//
//  Encode.swift
//  
//
//  Created by Danny Gilbert on 1/19/22.
//

import Foundation
#if canImport(Combine)
import Combine
#endif

#if !canImport(Combine)
public protocol TopLevelEncoder {
    associatedtype Output

    func encode<T: Encodable>(_ value: T) throws -> Self.Output
}

extension JSONEncoder: TopLevelEncoder { }
extension PropertyListEncoder: TopLevelEncoder { }
#endif

public struct Encode<Input: Encodable, Encoder: TopLevelEncoder>: Modifier {
    public typealias Output = Encoder.Output
    
    public let encoder: Encoder
    
    public init(
        _ encoder: Encoder
    ) {
        self.encoder = encoder
    }
    
    public func modify(_ record: Record<Input>, into: @escaping NewRecord<Output>) {
        record.modify(next: into) { record in
            try encoder.encode(record.output)
        }
    }
}

// MARK: - Modifier
public extension Modifier where
    Output: Encodable
{
    
    func encode<Encoder: TopLevelEncoder>(using encoder: Encoder) -> Concat<Self, Encode<Output, Encoder>> {
        self + .init(encoder)
    }
}
