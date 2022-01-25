//
//  Diary+Modifiers.swift
//  
//
//  Created by Danny Gilbert on 1/18/22.
//

import Foundation

public extension Diary {
    
    struct Modifiers { }
}

public extension Diary.Modifiers {
    
    struct Standard: Modifier {
        public typealias Input = Void
        public typealias Output = Void
    }
    
    static let standard = Standard()
}

// MARK: - BuiltIn - Modifiers
public extension Diary.Modifiers {
    
    static let short = standard
        .map {
            "\($0.entry.message)"
        }
        .newLine
    
    static let medium = standard
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
    
    static let long = standard
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
    
    private static let jsonEncoder: JSONEncoder = {
       let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        return encoder
    }()
    static let json = standard
        .encode(using: jsonEncoder)
        .compactMap {
            String(bytes: $0.output, encoding: .utf8)
        }
        .commaSeparated
        .newLine
}
