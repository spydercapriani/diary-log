//
//  Diary.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

// TODO: Let's maybe make this more bootstrappable...
public enum Diary { }

public extension Diary {
    
    static let console: Logger = .init(label: "com.diary.console") { label in
        let modifier = Diary.Modifiers
            .medium
        
        let stdOut = DiaryHandler(
            label: label,
            modifier: modifier,
            writer: TerminalWriter.stdout
        )
        if #available(macOS 10.12, *) {
            let os = DiaryHandler(
                label: label,
                modifier: modifier,
                writer: OSWriter()
            )
            
            return MultiplexLogHandler(
                [
                    stdOut,
                    os
                ]
            )
        } else {
            return stdOut
        }
    }
    
    @available(macOS 10.12, *)
    static let os: Logger = .init(label: "com.diary.os") { label in
        DiaryHandler(
            label: label,
            modifier: Diary.Modifiers.medium,
            writer: OSWriter()
        )
    }
}
