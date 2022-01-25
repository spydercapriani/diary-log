//
//  OSWriter.swift
//  
//
//  Created by Danny Gilbert on 1/19/22.
//

#if canImport(os)
import os

public struct OSWriter: Writer {
    
    public func write(_ record: Record<String>) throws {
        let subsystem = record.entry.metadata?["subsystem"] as? String
        let category = record.entry.metadata?["category"] as? String
        
        let osLog = OSLog(
            subsystem: subsystem ?? record.entry.label,
            category: category ?? record.entry.source
        )
        os_log("%{public}@", log: osLog, type: record.entry.level.osLogType, record.output)
    }
}
#endif
