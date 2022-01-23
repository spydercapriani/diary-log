//
//  LoggerLevel+.swift
//  
//
//  Created by Danny Gilbert on 1/18/22.
//

import Logging

public extension Logging.Logger.Level {
    
    var icon: String {
        switch self {
        case .trace:
            return "◼️"
        case .debug:
            return "◽️"
        case .info:
            return "🔷"
        case .notice:
            return "💠"
        case .warning:
            return "🔶"
        case .error:
            return "❌"
        case .critical:
            return "❗️"
        }
    }
}

#if canImport(os)
import os
@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
public extension Logging.Logger.Level {
    
    var osLogType: OSLogType {
        switch self {
        case .trace,        /// `OSLog` doesn't have `trace`, so use `debug`
            .debug:
            return .debug
        case .info,
            .notice,        /// `OSLog` doesn't have `notice`, so use `info`
            .warning:       /// `OSLog` doesn't have `warning`, so use `info`
            return .info
        case .error:
            return .error
        case .critical:
            return .fault
        }
    }
}
#endif
