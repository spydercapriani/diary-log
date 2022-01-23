//
//  When.swift
//  
//
//  Created by Danny Gilbert on 1/19/22.
//

public struct When<M: Modifier, T> {
    
    public let modifier: M
    public let transformer: Transformer
    
    public init(
        _ modifier: M,
        _ transformer: Transformer
    ) {
        self.modifier = modifier
        self.transformer = transformer
    }
}

// MARK: - Modifier
public extension Modifier {
    
    func when<T>(
        _ transform: @escaping BasicTransformer<Output, T>
    ) -> When<Self, T> {
        .init(self, .init(transform))
    }
    
    func when<T>(
        _ transformer: When<Self, T>.Transformer
    ) -> When<Self, T> {
        .init(self, transformer)
    }
    
    func when<T>(
        _ keyPath: KeyPath<Entry, T>
    ) -> When<Self, T> {
        .init(self, .init(keyPath))
    }
}
