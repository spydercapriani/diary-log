//
//  Writer.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

public protocol Writer {
    associatedtype Output
    
    func write(_ record: Record<Output>) throws
}
