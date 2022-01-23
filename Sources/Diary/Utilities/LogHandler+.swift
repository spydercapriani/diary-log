//
//  LogHandler+.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

public extension LogHandler {
    subscript(metadataKey key: String) -> Logger.MetadataValue? {
        get { metadata[key] }
        set(newValue) { metadata[key] = newValue }
    }
}
