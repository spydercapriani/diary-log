//
//  Diary.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

// TODO: Let's maybe make this more bootstrappable...
public enum Diary { }

public extension Diary {
    
    struct Log {
        public static let console: Logger = .init(label: "com.diary.console") { label in
            let modifier = DiaryModifiers
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
        public static let os: Logger = .init(label: "com.diary.os") { label in
            DiaryHandler(
                label: label,
                modifier: DiaryModifiers.medium,
                writer: OSWriter()
            )
        }
    }
}
