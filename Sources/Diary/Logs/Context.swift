//
//  Context.swift
//  
//
//  Created by Danny Gilbert on 1/20/22.
//

public protocol Context: Encodable {

    static var key: String { get }
}

// MARK: - Defaults
public extension Context {
    
    static var key: String {
        String(describing: self).camelCaseToSnakeCase()
    }
}
