//
//  Entry.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

public struct Entry {
    public var label: String
    public var level: Logger.Level
    public var message: Logger.Message
    public var source: String
    public var file: String
    public var function: String
    public var line: UInt
    public var metadata: Metadata?
}

// MARK: - Initializer
public extension Entry {
    
    init(
        label: String,
        level: Logger.Level,
        message: Logger.Message,
        source: String,
        file: String,
        function: String,
        line: UInt,
        metadata: Logger.Metadata?
    ) {
        self.label = label
        self.level = level
        self.message = message
        self.source = source
        self.file = file
        self.function = function
        self.line = line
        self.metadata = Metadata(metadata)
    }
}

// MARK: - Encodable
extension Entry: Encodable {
    
    enum StaticKeys: CodingKey {
        case label
        case level
        case message
        case source
        case file
        case function
        case line
    }

    public func encode(to encoder: Encoder) throws {
        var staticContainer = encoder.container(keyedBy: StaticKeys.self)
        try staticContainer.encode(label, forKey: .label)
        try staticContainer.encode(level, forKey: .level)
        try staticContainer.encode(message, forKey: .message)
        try staticContainer.encode(source, forKey: .source)
        try staticContainer.encode(file, forKey: .file)
        try staticContainer.encode(function, forKey: .function)
        try staticContainer.encode(line, forKey: .line)

        var dynamicContainer = encoder.container(keyedBy: AnyKey.self)
        for (k, v) in metadata?.metadata ?? [:] {
            guard
                let key = k.base as? String,
                let encodable = encoded(v)
            else {
                continue
            }
            try dynamicContainer.encode(encodable, forKey: .init(stringValue: key))
        }
    }
}

// MARK: - Encodable - Logger.Message
extension Logger.Message: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
