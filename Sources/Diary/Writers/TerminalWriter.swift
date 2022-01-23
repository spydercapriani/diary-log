//
//  TerminalWriter.swift
//  
//
//  Created by Danny Gilbert on 1/14/22.
//

public struct TerminalWriter: DiaryWriter {
    public let stream: TextOutputStream

    public init(_ stream: TextOutputStream) {
        self.stream = stream
    }

    public func write(_ record: Record<String>) throws {
        var stream = self.stream
        stream.write(record.output)
    }

    public static let stdout = TerminalWriter(StdOutputStream.out)
    public static let stderr = TerminalWriter(StdOutputStream.err)
}

// https://github.com/apple/swift-log/blob/main/Sources/Logging/Logging.swift
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    import Darwin
#elseif os(Windows)
    import MSVCRT
#else
    import Glibc
#endif
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
    private let stderr = Darwin.stderr
    private let stdout = Darwin.stdout
#elseif os(Windows)
    private let stderr = MSVCRT.stderr
    private let stdout = MSVCRT.stdout
#else
    private let stderr = Glibc.stderr!
    private let stdout = Glibc.stdout!
#endif

private struct StdOutputStream: TextOutputStream {
    private let file: UnsafeMutablePointer<FILE>

    func write(_ string: String) {
        #if os(Windows)
            _lock_file(file)
        #else
            flockfile(file)
        #endif
        defer {
            #if os(Windows)
                _unlock_file(self.file)
            #else
                funlockfile(self.file)
            #endif
        }

        string.withCString { ptr in
            _ = fputs(ptr, self.file)
            _ = fflush(self.file)
        }
    }

    static let out = StdOutputStream(file: stdout)
    static let err = StdOutputStream(file: stderr)
}

