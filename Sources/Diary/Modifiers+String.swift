//
//  Modifiers+String.swift
//  
//
//  Created by Danny Gilbert on 1/26/22.
//

public extension Modifiers {
    
    static let short = entry
        .map {
            "\($0.entry.message)"
        }
        .levelInfoPrefix
        .newLine
        .eraseToAnyModifier()
    
    static let medium = entry
        .map {
            let output = "\($0.entry.message)"
            if let metadata = $0.entry.metadata?.prettyMetadata {
                return output + "\n" + metadata
            } else {
                return output
            }
        }
        .separator
        .levelEmojiPrefix
        .newLine
        .eraseToAnyModifier()
    
    static let long = entry
        .map {
            let output = "\($0.entry.message)"
            if let metadata = $0.entry.metadata?.prettyMetadata {
                return output + "\n" + metadata
            } else {
                return output
            }
        }
        .separator
        .levelInfoPrefix
        .separator
        .levelEmojiPrefix
        .newLine
        .eraseToAnyModifier()
    
    static let jsonString = jsonData
        .compactMap {
            String(bytes: $0.output, encoding: .utf8)
        }
        .commaSeparated
        .newLine
        .eraseToAnyModifier()
}

