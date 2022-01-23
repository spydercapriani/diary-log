//
//  Matcher.swift
//  
//
//  Created by Danny Gilbert on 1/19/22.
//

public struct Matcher<M: Modifier, T> {
    
    public let when: When<M, T>
    public let match: (T) -> Bool
    
    public init(
        _ when: When<M, T>,
        _ match: @escaping (T) -> Bool
    ) {
        self.when = when
        self.match = match
    }
}

// MARK: - Match
public extension Matcher {
    
    struct Match: Modifier {
        public typealias Input = M.Input
        public typealias Output = M.Output
        
        public let match: Matcher
        public let action: Action
        
        public enum Action {
            case allow
            case deny
        }
        
        public init(
            _ match: Matcher,
            action: Action
        ) {
            self.match = match
            self.action = action
        }
        
        public func modify(_ record: Record<M.Input>, into: @escaping NewRecord<M.Output>) {
            record.modify(
                from: match.when.modifier,
                next: into
            ) { record in
                let t = match.when.transformer.transform(record)
                let matches = match.match(t)
                
                switch action {
                case .allow:
                    return matches ? record.output : nil
                case .deny:
                    return matches ? nil : record.output
                }
            }
        }
    }
}

// MARK: DSL - Matcher
public extension Matcher {
    
    var allow: Matcher.Match {
        .init(self, action: .allow)
    }
    
    var deny: Matcher.Match {
        .init(self, action: .deny)
    }
}
