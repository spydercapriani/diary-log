//
//  Modifier.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

public typealias NewRecord<Output> = (Result<Record<Output>?, Error>) -> Void

public protocol Modifier {
    associatedtype Input
    associatedtype Output
    
    func modify(_ record: Record<Input>, into: @escaping NewRecord<Output>)
}

// MARK: - Default Behavior
public extension Modifier where
    Input == Output
{
    func modify(
        _ record: Record<Input>,
        into: @escaping NewRecord<Output>
    ) {
        into(.success(record))
    }
}
