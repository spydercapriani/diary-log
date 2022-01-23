//
//  ThrowMap.swift
//  
//
//  Created by Danny Gilbert on 1/19/22.
//

public typealias ThrowableTransformer<Input, Output> = (Record<Input>) throws -> Output

public struct ThrowMap<Input, Output>: Modifier {
    
    let transform: ThrowableTransformer<Input, Output>
    
    public init(
        _ transform: @escaping ThrowableTransformer<Input, Output>
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
        _ transform: @escaping ThrowableTransformer<Output, NewOutput>
    ) -> Concat<Self, ThrowMap<Output, NewOutput>> {
        self + .init(transform)
    }
}
