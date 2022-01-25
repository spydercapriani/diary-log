//
//  Record.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

public struct Record<Output> {
    public var entry: Entry
    public let output: Output
    
    public init(
        _ entry: Entry,
        _ output: Output
    ) {
        self.entry = entry
        self.output = output
    }
}

public extension Record {
    
    func modify<NewOutput>(
        next: @escaping NewRecord<NewOutput>,
        transform: @escaping ComplexTransformer<Output, NewOutput>
    ) {
        do {
            guard let newOutput = try transform(self) else {
                next(.success(nil))
                return
            }
            
            next(.success(.init(entry, newOutput)))
        } catch {
            next(.failure(error))
        }
    }
    
    func modify<M: Modifier, NewOutput>(
        from: M,
        next: @escaping NewRecord<NewOutput>,
        transform: @escaping ComplexTransformer<M.Output, NewOutput>
    ) where
        M.Input == Output
    {
        from.modify(self) { result in
            switch result {
            case let .success(record):
                guard let record = record else {
                    next(.success(nil))
                    return
                }
                
                record.modify(next: next, transform: transform)
                
            case let .failure(error):
                next(.failure(error))
            }
        }
    }
}
