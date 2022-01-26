//
//  Logger+Init.swift
//  
//
//  Created by Danny Gilbert on 1/26/22.
//

// MARK: - Initializers
public extension Logger {
    
    init<M: Modifier, W: Writer>(
        label: String,
        modifier: M,
        _ writer: W
    ) where
        M.Output == W.Output
    {
        self = Logger(label: label) {
            DiaryHandler(
                label: $0,
                modifier: modifier,
                writer: writer
            )
        }
    }
    
    init<
        M: Modifier,
        A: Writer,
        B: Writer
    >(
        label: String,
        modifier: M,
        _ a: A,
        _ b: B
    ) where
        M.Output == A.Output,
        A.Output == B.Output
    {

        self = Logger(label: label) { label -> LogHandler in
            let handler1 = DiaryHandler(
                label: label,
                modifier: modifier,
                writer: a
            )
            let handler2 = DiaryHandler(
                label: label,
                modifier: modifier,
                writer: b
            )
            return MultiplexLogHandler([
                handler1,
                handler2
            ])
        }
    }

    init<
        M: Modifier,
        A: Writer,
        B: Writer,
        C: Writer
    >(
        label: String,
        modifier: M,
        _ a: A,
        _ b: B,
        _ c: C
    ) where
        M.Output == A.Output,
        A.Output == B.Output,
        B.Output == C.Output
    {

        self = Logger(label: label) { label -> LogHandler in
            let handler1 = DiaryHandler(
                label: label,
                modifier: modifier,
                writer: a
            )
            let handler2 = DiaryHandler(
                label: label,
                modifier: modifier,
                writer: b
            )
            let handler3 = DiaryHandler(
                label: label,
                modifier: modifier,
                writer: c
            )
            return MultiplexLogHandler([
                handler1,
                handler2,
                handler3
            ])
        }
    }

    init<
        M: Modifier,
        A: Writer,
        B: Writer,
        C: Writer,
        D: Writer
    >(
        label: String,
        modifier: M,
        _ a: A,
        _ b: B,
        _ c: C,
        _ d: D
    ) where
        M.Output == A.Output,
        A.Output == B.Output,
        B.Output == C.Output,
        C.Output == D.Output
    {

        self = Logger(label: label) { label -> LogHandler in
            let handler1 = DiaryHandler(
                label: label,
                modifier: modifier,
                writer: a
            )
            let handler2 = DiaryHandler(
                label: label,
                modifier: modifier,
                writer: b
            )
            let handler3 = DiaryHandler(
                label: label,
                modifier: modifier,
                writer: c
            )
            let handler4 = DiaryHandler(
                label: label,
                modifier: modifier,
                writer: d
            )
            return MultiplexLogHandler([
                handler1,
                handler2,
                handler3,
                handler4
            ])
        }
    }
}