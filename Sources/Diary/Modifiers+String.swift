//
//  Modifiers+String.swift
//  
//
//  Created by Danny Gilbert on 1/26/22.
//

public extension Modifiers {
    
    static let short = base
        .format(
            \.message.description
        )
        .separator
        .prefix(
            \.level.emoji
        )
        .newLine
        .eraseToAnyModifier()
    
    static let medium = base
        .format(
            \.message.description
        )
        .separator
        .prefix(
            \.level.emoji,
            \.level.rawValue.localizedUppercase,
            \.label,
            \.source
        )
        .newLine
        .eraseToAnyModifier()
    
    static let long = base
        .map {
            let output = "Message: \($0.entry.message)"
            if let metadata = $0.entry.metadata?.prettyMetadata {
                return "\n" + output + "\nMetadata:\n" + metadata
            } else {
                return "\n" + output
            }
        }
        .prefix(
            \.level.emoji,
            \.level.rawValue.localizedUppercase,
            \.label,
            \.source,
            \.function,
            \.line.description
        )
        .newLine
        .eraseToAnyModifier()
    
    static let jsonString = jsonData
        .stringValue()
        .commaSeparated
        .newLine
        .eraseToAnyModifier()
}

