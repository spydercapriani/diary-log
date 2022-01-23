//
//  Append.swift
//  
//
//  Created by Danny Gilbert on 1/22/22.
//

public struct Append<C: Context, Input>: Modifier {
    public typealias Output = Input
    
    private let context: C
    
    public init(
        _ context: C
    ) {
        self.context = context
    }
    
    public func modify(_ record: Record<Input>, into: @escaping NewRecord<Output>) {
        var updatedRecord = record
        if var existingMetadata = updatedRecord.entry.metadata {
            existingMetadata[C.key] = context
            updatedRecord.entry.metadata = existingMetadata
        } else {
            updatedRecord.entry.metadata = [C.key: context]
        }
        into(.success(updatedRecord))
    }
}

// MARK: - Modifier
public extension Modifier {
    
    func append<C: Context>(
        _ context: C
    ) -> Concat<Self, Append<C, Output>> {
        self + .init(context)
    }
}
