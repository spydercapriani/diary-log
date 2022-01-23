//
//  Map.swift
//  
//
//  Created by Danny Gilbert on 1/19/22.
//

public typealias BasicTransformer<Input, Output> = (Record<Input>) -> Output

public struct Map<Input, Output>: Modifier {
    
    let transform: BasicTransformer<Input, Output>
    
    public init(
        _ transfom: @escaping BasicTransformer<Input, Output>
    ) {
        self.transform = transfom
    }
    
    public func modify(_ record: Record<Input>, into: @escaping NewRecord<Output>) {
        record.modify(next: into) { (record) -> Output? in
            self.transform(record)
        }
    }
}

// MARK: - Modifier
public extension Modifier {
    
    func map<NewOutput>(
        _ transform: @escaping BasicTransformer<Output, NewOutput>
    ) -> Concat<Self, Map<Output, NewOutput>> {
        self + .init(transform)
    }
}
