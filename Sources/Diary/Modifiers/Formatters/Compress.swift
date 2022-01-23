//
//  Compress.swift
//  
//
//  Created by Danny Gilbert on 1/22/22.
//

import Foundation
#if canImport(Compression)
import Compression

public struct Compress: Modifier {
    
    public let algorithm: compression_algorithm
    
    public init(
        _ algorithm: compression_algorithm
    ) {
        self.algorithm = algorithm
    }
    
    public func modify(_ record: Record<Data>, into: @escaping NewRecord<Data>) {
        record.modify(next: into) { record in
            guard !record.output.isEmpty else { return record.output }
            return compress(
                input: record.output,
                algorithm: algorithm
            )
        }
    }
    
    // https://www.raywenderlich.com/7181017-unsafe-swift-using-pointers-and-interacting-with-c
    private func compress(
        input: Data,
        algorithm: compression_algorithm
    ) -> Data? {
        let operation = COMPRESSION_STREAM_ENCODE
        let flags = Int32(COMPRESSION_STREAM_FINALIZE.rawValue)

        let streamPointer = UnsafeMutablePointer<compression_stream>.allocate(capacity: 1)
        defer {
            streamPointer.deallocate()
        }

        var stream = streamPointer.pointee

        var status = compression_stream_init(&stream, operation, algorithm)

        guard status != COMPRESSION_STATUS_ERROR else {
            return nil
        }

        defer {
            compression_stream_destroy(&stream)
        }

        let bufferSize = 2 * 1024

        let dstSize = bufferSize
        let dstPointer = UnsafeMutablePointer<UInt8>.allocate(capacity: dstSize)

        defer {
            dstPointer.deallocate()
        }

        return input.withUnsafeBytes { srcRawBufferPointer -> Data? in
            var output = Data()

            let srcBufferPoint = srcRawBufferPointer.bindMemory(to: UInt8.self)

            guard let srcPointer = srcBufferPoint.baseAddress else {
                return nil
            }

            stream.src_ptr = srcPointer
            stream.src_size = input.count
            stream.dst_ptr = dstPointer
            stream.dst_size = dstSize

            while status == COMPRESSION_STATUS_OK {
                status = compression_stream_process(&stream, flags)

                switch status {
                case COMPRESSION_STATUS_OK:
                    output.append(dstPointer, count: dstSize)
                    stream.dst_ptr = dstPointer
                    stream.dst_size = dstSize

                case COMPRESSION_STATUS_ERROR:
                    return nil
                case COMPRESSION_STATUS_END:

                    output.append(dstPointer, count: stream.dst_ptr - dstPointer)

                default:
                    return nil
                }
            }

            return output
        }
    }
}

// MARK: - Modifier
public extension Modifier where Output == Data {
    
    func compress(_ algorithm: compression_algorithm) -> Concat<Self, Compress> {
        self + .init(algorithm)
    }
}
#endif
