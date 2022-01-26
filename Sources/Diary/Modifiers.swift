//
//  Modifiers.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

public enum Modifiers { }

public extension Modifiers {
    
    static let base = Base()
    static let empty = Empty()
}

public extension Modifiers {
    
    /// Provides a blank slate to start with.
    struct Empty: Modifier {
        public typealias Input = Void
        public typealias Output = Void
    }

    /// Provides the entry as starting point.
    struct Base: Modifier {
        public typealias Input = Void
        public typealias Output = Entry
        
        public func modify(
            _ record: Record<Input>,
            into: @escaping NewRecord<Output>
        ) {
            let initialRecord = Record(record.entry)
            into(.success(initialRecord))
        }
    }
}
