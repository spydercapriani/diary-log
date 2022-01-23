//
//  Encrypt.swift
//  
//
//  Created by Danny Gilbert on 1/22/22.
//

import Foundation
#if canImport(CryptoKit)
import CryptoKit

public struct Encrypt: Modifier {
    
    public let key: SymmetricKey
    public let cipher: Cipher
    
    public init(
        _ key: SymmetricKey,
        _ cipher: Cipher
    ) {
        self.key = key
        self.cipher = cipher
    }
    
    public func modify(_ record: Record<Data>, into: @escaping NewRecord<Data>) {
        record.modify(next: into) { record in
            switch cipher {
            case .AES:
                return try AES.GCM.seal(
                    record.output,
                    using: key
                )
                .combined
            case .ChaChaPoly:
                return try ChaChaPoly.seal(
                    record.output,
                    using: key
                )
                .combined
            }
        }
    }
}

// MARK: - Cipher
public extension Encrypt {
    
    enum Cipher {
        case AES
        case ChaChaPoly
    }
}

// MARK: - Modifier
public extension Modifier where Output == Data {
    
    func encrypt(using key: SymmetricKey, cipher: Encrypt.Cipher = .ChaChaPoly) -> Concat<Self, Encrypt> {
        self + .init(key, cipher)
    }
}
#endif
