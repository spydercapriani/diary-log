//
//  CompactMap.swift
//  
//
//  Created by Danny Gilbert on 1/19/22.
//

import Foundation

public typealias OptionalTransformer<Input, Output> = (Record<Input>) -> Output?

public struct CompactMap<Input, Output>: Modifier {
    
    let transform: OptionalTransformer<Input, Output>
    
    public init(
        _ transform: @escaping OptionalTransformer<Input, Output>
    ) {
        self.transform = transform
    }
    
    public func modify(_ record: Record<Input>, into: @escaping NewRecord<Output>) {
        record.modify(next: into) { [self] record in
            transform(record)
        }
    }
}

// MARK: - Modifier
public extension Modifier {
    
    func compactMap<NewOutput>(
        _ transform: @escaping OptionalTransformer<Output, NewOutput>
    ) -> Concat<Self, CompactMap<Output, NewOutput>> {
        self + .init(transform)
    }
}

public extension Modifier where
    Output == Data
{
    func stringValue(
        encoding: String.Encoding = .utf8
    ) -> Concat<Self, CompactMap<Output, String>> {
        self + .init {
            String(bytes: $0.output, encoding: encoding)
        }
    }
}
