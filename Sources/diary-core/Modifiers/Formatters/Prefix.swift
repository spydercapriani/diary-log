//
//  Prefix.swift
//  
//
//  Created by Danny Gilbert on 1/18/22.
//

public struct Prefix<T: RangeReplaceableCollection>: Modifier {
    public typealias Input = T
    public typealias Output = T
    
    public let transformer: BasicTransformer<Input, Output>
    
    public init(
        _ handler: @escaping BasicTransformer<Input, Output>
    ) {
        self.transformer = handler
    }
    
    public init(
        prefix: T
    ) {
        self.init { _ in
            prefix
        }
    }
    
    public func modify(_ record: Record<T>, into: @escaping NewRecord<T>) {
        record.modify(next: into) { record in
            let prefix = transformer(record)
            return prefix + record.output
        }
    }
}

// MARK: - Modifier - RangeReplaceableCollection
public extension Modifier where
    Output: RangeReplaceableCollection
{
    
    func prefix(
        _ prefix: @escaping BasicTransformer<Output, Output>
    ) -> Concat<Self, Prefix<Output>> {
        self + Prefix<Output>(prefix)
    }
    
    func prefix(
        _ prefix: Output
    ) -> Concat<Self, Prefix<Output>> {
        self + Prefix<Output>(prefix: prefix)
    }
}

// MARK: - BuiltIn - String
public extension Modifier where
    Output == String
{
    
    var levelEmojiPrefix: Concat<Self, Prefix<Output>> {
        self + Prefix<Output> {
            "\($0.entry.level.icon)"
        }
    }
    
    var separator: Concat<Self, Prefix<Output>> {
        self + .init(prefix: " ▶ ")
    }
    
    var levelInfoPrefix: Concat<Self, Prefix<Output>> {
        self + Prefix<Output> {
            "[\($0.entry.level.rawValue.uppercased())]"
        }
    }
}
