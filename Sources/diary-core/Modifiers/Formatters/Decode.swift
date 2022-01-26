//
//  Decode.swift
//  
//
//  Created by Danny Gilbert on 1/20/22.
//

import Foundation
#if canImport(Combine)
import Combine
#endif

#if !canImport(Combine)
public protocol TopLevelDecoder {
    associatedtype Input
    
    func decode<T: Decodable>(_ type: T.Type, from: Self.Input) throws -> T
}

extension JSONDecoder: TopLevelDecoder { }
extension PropertyListDecoder: TopLevelDecoder { }
#endif

public struct Decode<Decoder: TopLevelDecoder, Output: Decodable>: Modifier {
    public typealias Input = Decoder.Input
    
    public let decoder: Decoder
    public let type: Output.Type
    
    public init(
        _ decoder: Decoder,
        _ type: Output.Type
    ) {
        self.decoder = decoder
        self.type = type
    }
    
    public func modify(_ record: Record<Input>, into: @escaping NewRecord<Output>) {
        record.modify(next: into) { record in
            try decoder.decode(type, from: record.output)
        }
    }
}

// MARK: - Modifier
public extension Modifier where
    Output == Data
{
    
    func decode<Decoder: TopLevelDecoder, T>(_ type: T.Type, using decoder: Decoder) -> Concat<Self, Decode<Decoder, T>> {
        self + .init(decoder, type)
    }
}
