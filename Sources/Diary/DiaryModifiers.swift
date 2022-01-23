//
//  DiaryModifiers.swift
//  
//
//  Created by Danny Gilbert on 1/18/22.
//

import Foundation

public enum DiaryModifiers { }

public extension DiaryModifiers {
    
    struct Blank: Modifier {
        public typealias Input = Void
        public typealias Output = Void
    }
    
    static let standard = Blank()
}

public extension DiaryModifiers {
    
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
