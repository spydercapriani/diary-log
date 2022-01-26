//
//  AnyModifier.swift
//  
//
//  Created by Danny Gilbert on 1/26/22.
//

public struct AnyModifier<Input, Output>: Modifier {
    
    private let abstract: Abstract<Input, Output>
    
    public init<M: Modifier>(
        _ modifier: M
    ) where
        M.Input == Input,
        M.Output == Output
    {
        self.abstract = ModifierBox(modifier)
    }
    
    public func modify(_ record: Record<Input>, into: @escaping NewRecord<Output>) {
        abstract.modify(record, into: into)
    }
}

private class Abstract<Input, Output>: Modifier {
    func modify(_ record: Record<Input>, into: @escaping NewRecord<Output>) {
        fatalError("Implemented in subclasses")
    }
}

private final class ModifierBox<M: Modifier>: Abstract<M.Input, M.Output> {
    
    private let modifier: M
    
    init(_ modifier: M) {
        self.modifier = modifier
    }
    
    override func modify(_ record: Record<M.Input>, into: @escaping NewRecord<M.Output>) {
        modifier.modify(record, into: into)
    }
}

// MARK: - Modifier
public extension Modifier {

    func eraseToAnyModifier() -> AnyModifier<Input, Output> {
        .init(self)
    }
}
