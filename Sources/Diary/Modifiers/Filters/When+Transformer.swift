//
//  When+Transformer.swift
//  
//
//  Created by Danny Gilbert on 1/19/22.
//

public extension When {
    
    struct Transformer {
        public let transform: BasicTransformer<M.Output, T>
        
        public init(
            _ transformer: @escaping BasicTransformer<M.Output, T>
        ) {
            self.transform = transformer
        }
        
        public init(
            _ keyPath: KeyPath<Entry, T>
        ) {
            self.init {
                $0.entry[keyPath: keyPath]
            }
        }
    }
}

// MARK: - BuiltIn
public extension When.Transformer {
    
    static var message: When<M, String>.Transformer {
        .init { "\($0.entry.message)" }
    }
    
    static var fileName: When<M, String>.Transformer {
        .init { Helpers.basename(ofPath: $0.entry.file) }
    }
}
