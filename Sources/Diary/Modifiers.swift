//
//  Modifiers.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

public enum Modifiers { }

public extension Modifiers {
    
    static let entry = Standard()
    static let empty = Empty()
}

public extension Modifiers {
    
    struct Empty: Modifier {
        public typealias Input = Void
        public typealias Output = Void
    }

    struct Standard: Modifier {
        public typealias Input = Entry
        public typealias Output = Entry
    }
}
