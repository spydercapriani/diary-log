//
//  Logger+Init.swift
//  
//
//  Created by Danny Gilbert on 1/26/22.
//

// MARK: - Initializers
public extension Logger {
    
    init<M: Modifier>(
        label: String,
        modifier: M,
        _ writer: AnyWriter<M.Output>...
    ) {
        self = Logger(label: label) { label in
            let handlers = writer.map { writer in
                DiaryHandler(
                    label: label,
                    modifier: modifier,
                    writer: writer
                )
            }
            return MultiplexLogHandler(handlers)
        }
    }
    
    init<M: Modifier, W: Writer>(
        label: String,
        modifier: M,
        writer: W
    ) where
        M.Output == W.Output
    {
        self.init(
            label: label,
            modifier: modifier,
            writer.eraseToAnyWriter()
        )
    }
}
