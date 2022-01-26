//
//  DiaryHandler.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

import Logging

public struct DiaryHandler<M: Modifier, W: Writer>: LogHandler where
    M.Output == W.Output
{
    
    public let label: String
    public var metadata: Logger.Metadata
    public var logLevel: Logger.Level
    
    public let modifier: M
    public let writer: W
    
    private let errorHandler: ((Error) -> Void)?
}

// MARK: - Initializers
extension DiaryHandler {
    
    public init(
        label: String,
        modifier: M,
        writer: W,
        level: Logger.Level = .trace,
        metadata: Logger.Metadata = [:],
        errorHandler: ((Error) -> Void)? = nil
    ) {
        self.label = label
        self.modifier = modifier
        self.writer = writer
        self.logLevel = level
        self.metadata = metadata
        self.errorHandler = errorHandler
    }
}

// MARK: - LogHandler - Standard
extension DiaryHandler where
    M.Input == Entry
{
    
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let entry = Entry(
            label: label,
            level: level,
            message: message,
            source: source,
            file: file,
            function: function,
            line: line,
            metadata: metadata
        )
        let record = Record(entry, entry)
        modifier.modify(record) { result in
            switch result {
            case let .success(newRecord):
                do {
                    try newRecord.map {
                        try writer.write($0)
                    }
                } catch {
                    errorHandler?(error)
                }
            case let .failure(error):
                errorHandler?(error)
            }
        }
    }
}

// MARK: - LogHandler - Custom
extension DiaryHandler where
    M.Input == Void
{
    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        let entry = Entry(
            label: label,
            level: level,
            message: message,
            source: source,
            file: file,
            function: function,
            line: line,
            metadata: metadata
        )
        let record = Record(entry, ())
        modifier.modify(record) { result in
            switch result {
            case let .success(newRecord):
                do {
                    try newRecord.map {
                        try writer.write($0)
                    }
                } catch {
                    errorHandler?(error)
                }
            case let .failure(error):
                errorHandler?(error)
            }
        }
    }
}
