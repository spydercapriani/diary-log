//
//  Append.swift
//  
//
//  Created by Danny Gilbert on 1/22/22.
//

public struct Append<C: Context>: Modifier {
    public typealias Output = Entry
    
    private let context: C
    
    public init(
        _ context: C
    ) {
        self.context = context
    }
    
    public func modify(_ record: Record<Input>, into: @escaping NewRecord<Output>) {
        var updatedEntry = record.entry
        if var existingMetadata = updatedEntry.metadata {
            existingMetadata[C.key] = context
            updatedEntry.metadata = existingMetadata
        } else {
            updatedEntry.metadata = [C.key: context]
        }
        into(.success(.init(updatedEntry, updatedEntry)))
    }
}

// MARK: - Modifier
public extension Modifier where
    Output == Entry
{
    
    func append<C: Context>(
        _ context: C
    ) -> Concat<Self, Append<C>> {
        self + .init(context)
    }
}
