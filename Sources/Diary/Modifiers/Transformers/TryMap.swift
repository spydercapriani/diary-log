//
//  TryMap.swift
//  
//
//  Created by Danny Gilbert on 1/18/22.
//

public typealias ComplexTransformer<Input, Output> = (Record<Input>) throws -> Output?

public struct TryMap<Input, Output>: Modifier {
    
    let transform: ComplexTransformer<Input, Output>
    
    public init(
        _ transform: @escaping ComplexTransformer<Input, Output>
    ) {
        self.transform = transform
    }
    
    public func modify(_ record: Record<Input>, into: @escaping NewRecord<Output>) {
        record.modify(next: into) { [self] record in
            try transform(record)
        }
    }
}

// MARK: - Modifier
public extension Modifier {
    
    func tryMap<NewOutput>(
        _ transform: @escaping ComplexTransformer<Output, NewOutput>
    ) -> Concat<Self, TryMap<Output, NewOutput>> {
        self + .init(transform)
    }
}
