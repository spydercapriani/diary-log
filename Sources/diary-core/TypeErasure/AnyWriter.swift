//
//  AnyWriter.swift
//  
//
//  Created by Danny Gilbert on 1/26/22.
//

public struct AnyWriter<Output>: Writer {
    private let abstract: Abstract<Output>
    
    public init<W: Writer>(_ writer: W) where W.Output == Output {
        self.abstract = WriterBox(writer)
    }
    
    public func write(_ record: Record<Output>) throws {
        try abstract.write(record)
    }
}

private class Abstract<Output>: Writer {
    func write(_ record: Record<Output>) throws {
        fatalError("Implement in subclasses")
    }
}

private final class WriterBox<W: Writer>: Abstract<W.Output> {
    private let writer: W
    
    init(_ writer: W) {
        self.writer = writer
    }
    
    override func write(_ record: Record<W.Output>) throws {
        try writer.write(record)
    }
}

public extension Writer {
    
    func eraseToAnyWriter() -> AnyWriter<Output> {
        AnyWriter(self)
    }
}
