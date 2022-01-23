//
//  Helpers.swift
//  
//
//  Created by Danny Gilbert on 1/19/22.
//

public enum Helpers { }

public extension Helpers {
    
    static func basename(ofPath path: String, withExtensions: Bool = true) -> String {
        guard let index = path.lastIndex(of: "/") else { return path }
        
        let from = path.index(after: index)
        let filename = String(path[from...])
        
        if withExtensions {
            return filename
        }
        
        if let dot = filename.lastIndex(of: ".") {
            return String(filename[..<dot])
        }
        
        return filename
    }
}

func unwrap(_ any: Any?) -> Any? {
    guard let any = any else {
        return nil
    }

    let mirror = Mirror(reflecting: any)

    if mirror.displayStyle != .optional {
        return any
    }

    if let (_, any) = mirror.children.first {
        return unwrap(any)
    }

    return nil
}

func convert(_ value: Logger.MetadataValue) -> Any {
    switch value {
    case let .string(string):
        return string
    case let .stringConvertible(convertible):
        return convertible
    case let .dictionary(dict):
        return dict.mapValues(convert)
    case let .array(list):
        return list.map(convert)
    }
}

func encoded(_ any: Any?) -> AnyEncodable? {
    guard let any = unwrap(any) else {
        return AnyEncodable(AnyEncodable?.none)
    }

    switch any {
    case let codable as Encodable:
        return AnyEncodable(codable)
        
    case let array as [Any?]:
        var elements: [AnyEncodable] = []
        
        for element in array {
            guard let encodable = encoded(element) else { return nil }
            elements.append(encodable)
        }
        
        return AnyEncodable(elements)
    case let dictionary as [String: Any?]:
        var dict: [String: AnyEncodable] = [:]
        
        for (k, v) in dictionary {
            guard let encodable = encoded(v) else { continue }
            dict[k] = encodable
        }
        
        return AnyEncodable(dict)
        
    default: return nil
    }
}
