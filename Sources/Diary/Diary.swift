//
//  Diary.swift
//  
//
//  Created by Danny Gilbert on 1/25/22.
//

// Global Default Diary
public var diary: Logger = .diary(label: "diary")

// MARK: - Defaults
public extension Logger {
    static func diary(
        label: String,
        modifier: AnyModifier<Entry,String> = Modifiers.medium
    ) -> Logger {
        Logger(
            label: label,
            modifier: modifier,
            writers: [
                TerminalWriter.stdout.eraseToAnyWriter(),
                OSWriter().eraseToAnyWriter()
            ]
        )
    }
}
