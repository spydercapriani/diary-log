//
//  When+DSL.swift
//  
//
//  Created by Danny Gilbert on 1/19/22.
//

// MARK: DSL - StringProtocol
public extension When where T: StringProtocol {
    
    func contains(_ other: T) -> Matcher<M, T> {
        .init(self) { $0.contains(other) }
    }
    
    func includes(_ other: T) -> Matcher<M, T> {
        contains(other)
    }
    
    func excludes(_ other: T) -> Matcher<M, T> {
        .init(self) { !$0.contains(other) }
    }
    
    func hasPrefix(_ prefix: T) -> Matcher<M, T> {
        .init(self) { $0.hasPrefix(prefix) }
    }
    
    func hasSuffix(_ suffix: T) -> Matcher<M, T> {
        .init(self) { $0.hasSuffix(suffix) }
    }
    
    func starts(with prefix: T) -> Matcher<M, T> {
        hasPrefix(prefix)
    }
    
    func ends(with suffix: T) -> Matcher<M, T> {
        hasSuffix(suffix)
    }
}

// MARK: - DSL - String
public extension When where T == String {
    
    func matches(regEx: String) -> Matcher<M, T> {
        .init(self) {
            $0.range(of: regEx, options: .regularExpression) != nil
        }
    }
}

// MARK: DSL - Entry.Metadata
public extension When where T == Entry.Metadata {
    
    func contains(key: AnyHashable) -> Matcher<M, T> {
        .init(self) { $0.metadata.keys.contains(key) }
    }
    
    func contains<V: Equatable>(_ value: V) -> Matcher<M, T> {
        .init(self) {
            $0.metadata.values.contains { element in
                guard
                    let output = element as? V
                else { return false }
                return output == value
            }
        }
    }
}

// MARK: - DSL - Equatable
public extension When where T: Equatable {
    
    func equals(_ other: T) -> Matcher<M, T> {
        .init(self) { $0 == other }
    }
}

// MARK: - DSL - Comparable
public extension When where T: Comparable {
    
    func greaterThan(_ comp: T) -> Matcher<M, T> {
        .init(self) { $0 > comp }
    }
    
    func greaterThanOrEqualTo(_ comp: T) -> Matcher<M, T> {
        .init(self) { $0 >= comp }
    }
    
    func lessThan(_ comp: T) -> Matcher<M, T> {
        .init(self) { $0 < comp }
    }
    
    func lessThanOrEqualTo(_ comp: T) -> Matcher<M, T> {
        .init(self) { $0 <= comp }
    }
}
