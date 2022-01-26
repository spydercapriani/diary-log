//
//  BuiltIn.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

public enum BuiltIn { }

public extension BuiltIn {
    
    struct Modifiers { }
}

// MARK: - Basic Modifiers
public extension BuiltIn.Modifiers {
    
    struct Standard: Modifier {
        public typealias Input = Entry
        public typealias Output = Entry
    }
    
    struct Empty: Modifier {
        public typealias Input = Void
        public typealias Output = Void
    }
    
    static let standard = Standard()
    
    static let empty = Empty()
}
