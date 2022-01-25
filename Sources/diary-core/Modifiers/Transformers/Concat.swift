//
//  Concat.swift
//  
//
//  Created by Danny Gilbert on 1/18/22.
//

public struct Concat<A: Modifier, B: Modifier>: Modifier where
    A.Output == B.Input
{
    public typealias Input = A.Input
    public typealias Output = B.Output
    
    public let a: A
    public let b: B
    
    public init(
        _ a: A,
        _ b: B
    ) {
        self.a = a
        self.b = b
    }
    
    public func modify(_ record: Record<A.Input>, into: @escaping NewRecord<B.Output>) {
        a.modify(record) { result in
            switch result {
            case let .success(record):
                guard let record = record else {
                    into(.success(nil))
                    return
                }
                b.modify(record, into: into)
            case let .failure(error):
                into(.failure(error))
            }
        }
    }
}

// MARK: - Modifier - Helpers
public extension Modifier {
    
    func concat<M: Modifier>(_ other: M) -> Concat<Self, M> where
        M.Input == Output
    {
        .init(self, other)
    }
}

public func + <A: Modifier, B: Modifier>(_ a: A, _ b: B) -> Concat<A, B> where
    B.Input == A.Output
{
    a.concat(b)
}
