//
//  main.swift
//  
//  Playground for testing things via terminal.
//  Created by Danny Gilbert on 1/14/22.
//

import Diary
import Logging
import Foundation

let errorHandler: ((Error) -> Void) = { error in
    print("There was an error: \(error)")
}

func demo(_ logger: Logger) {
    logger.trace("trace")
    logger.debug("debug")
    logger.info("info")
    logger.notice("notice")
    logger.warning("warning")
    logger.error("error")
    logger.critical("critical")
    logger.info(
        "Hello, World!",
        metadata: [
            "current_dir": "~/Downloads",
            "PID": "3194"
        ],
        source: "demo-playground"
    )
    logger.info(
        "OS Log Sample",
        metadata: [
            "subsystem": "example-subsystem",
            "category": "example-category"
        ]
    )
}

let filterLogger = Logger(label: "com.playground.filter") { label in
    let modifier = Modifiers.long
        .filter {
            $0.entry.level == .info
        }
    
    return DiaryHandler(
        label: label,
        modifier: modifier,
        writer: TerminalWriter.stdout
    )
}

let customLogger = Logger(label: "com.playground.custom") { label in
    let modifier = Modifiers.base
        .map {
            "\($0.entry.message)"
        }
        .prefix("[CUSTOM] - ")
        .suffix(" - [HELLO]")
        .newLine
    
    return DiaryHandler(
        label: label,
        modifier: modifier,
        writer: TerminalWriter.stdout
    )
}

let matcher = Logger(label: "com.playground.matcher") { label in
    let modifier = Modifiers.medium
        .when(\.entry.level)
        .greaterThanOrEqualTo(.warning)
        .allow
    
//        .when(.message)
//        .contains("info")
//        .deny
    
//        .when(.metadata)
//        .contains(key: "subsystem")
//        .contains((key: "subsystem", value: "example-subsystem"))
//        .contains(value: "example-subsystem")
//        .allow
    
//        .when(\.entry.source)
//        .equals("Playground")
//        .allow
    
    return DiaryHandler(
        label: label,
        modifier: modifier,
        writer: TerminalWriter.stdout
    )
}

let encodedLogger = Logger(label: "com.playground.encoder") { label in
    DiaryHandler(
        label: label,
        modifier: Modifiers.jsonString,
        writer: TerminalWriter.stdout
    )
}

let decodedLogger = Logger(label: "com.playground.decoder") { label in
    struct EntryClone: Decodable {
        let file: String
        let function: String
        let level: Logger.Level
        let message: String
    }
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    
    let modifier = Modifiers.base
        .encode(using: encoder)
        .decode(EntryClone.self, using: decoder)
        .map { record in
            "\(record.entry.message) - \(record.entry.level)"
        }
        .newLine
    
    return DiaryHandler(
        label: label,
        modifier: modifier,
        writer: TerminalWriter.stdout
    )
}

let encodedLogger2 = Logger(label: "com.playground.encoder2") { label in
    struct Custom: Context {
        let info = "Some Custom Info"
        let date = Date()
    }
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
    
    let modifier = Modifiers.base
        .append(Custom())
        .encode(using: encoder)
        .stringValue()
        .commaSeparated
        .newLine
    
    return DiaryHandler(
        label: label,
        modifier: modifier,
        writer: TerminalWriter.stdout,
        errorHandler: errorHandler
    )
}

//demo(diary)
//demo(filterLogger)
//demo(customLogger)
//demo(matcher)
//demo(encodedLogger)
//demo(decodedLogger)
demo(encodedLogger2)
//demo(.diary(label: "com.playground.short", modifier: Modifiers.short))
//demo(.diary(label: "com.playground.medium", modifier: Modifiers.medium))
//demo(.diary(label: "com.playground.long", modifier: Modifiers.long))

//var modifiedDiary = Logger.diary(label: "com.playground.metadata", modifier: Modifiers.jsonString)
//modifiedDiary[metadataKey: "app_name"] = "MyApp"
//demo(modifiedDiary)
