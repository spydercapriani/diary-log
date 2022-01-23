//
//  Filter.swift
//  
//
//  Created by Danny Gilbert on 1/19/22.
//

public typealias RecordFilter<Output> = (Record<Output>) throws -> Bool

public struct Filter<Output>: Modifier {
    public typealias Input = Output
    
    public let isIncluded: RecordFilter<Output>
    
    public init(
        isIncluded: @escaping RecordFilter<Output>
    ) {
        self.isIncluded = isIncluded
    }
    
    public func modify(_ record: Record<Input>, into: @escaping NewRecord<Output>) {
        record.modify(next: into) { (record) -> Output? in
            try self.isIncluded(record) ? record.output : nil
        }
    }
}

// MARK: - Modifier
public extension Modifier {
    
    func filter(
        _ isIncluded: @escaping (Record<Output>) throws -> Bool
    ) -> Concat<Self, Filter<Output>> {
        self + .init(isIncluded: isIncluded)
    }
}
