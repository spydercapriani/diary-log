//
//  Diary.swift
//  
//
//  Created by Danny Gilbert on 1/25/22.
//

// Global Default Diary
public var Diary: Logger = .diary(label: "diary")

// MARK: - Defaults
public extension Logger {
    static func diary(
        label: String,
        modifier: AnyModifier<Void, String> = Modifiers.short
    ) -> Logger {
        Logger(
            label: label,
            modifier: modifier,
            TerminalWriter.stdout.eraseToAnyWriter(),
            OSWriter().eraseToAnyWriter()
        )
    }
}
