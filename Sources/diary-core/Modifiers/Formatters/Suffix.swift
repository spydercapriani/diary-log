//
//  Suffix.swift
//  
//
//  Created by Danny Gilbert on 1/18/22.
//

public struct Suffix<T: RangeReplaceableCollection>: Modifier {
    public typealias Input = T
    public typealias Output = T
    
    public let transformer: BasicTransformer<Input, Output>
    
    public init(
        _ handler: @escaping BasicTransformer<Input, Output>
    ) {
        self.transformer = handler
    }
    
    public init(
        suffix: T
    ) {
        self.init { _ in
            suffix
        }
    }
    
    public func modify(_ record: Record<T>, into: @escaping NewRecord<T>) {
        record.modify(next: into) { record in
            let suffix = transformer(record)
            return record.output + suffix
        }
    }
}

// MARK: - Modifier - RangeReplaceableCollection
public extension Modifier where Output: RangeReplaceableCollection {
    
    func suffix(
        _ suffix: @escaping BasicTransformer<Output, Output>
    ) -> Concat<Self, Suffix<Output>> {
        self + Suffix<Output>(suffix)
    }
    
    func suffix(
        _ suffix: Output
    ) -> Concat<Self, Suffix<Output>> {
        self + Suffix<Output>(suffix: suffix)
    }
}

// MARK: - BuiltIn - String
public extension Modifier where Output == String {
    
    var newLine: Concat<Self, Suffix<Output>> {
        self + .init(suffix: "\n")
    }
    
    var commaSeparated: Concat<Self, Suffix<Output>> {
        self + .init(suffix: ",")
    }
}
