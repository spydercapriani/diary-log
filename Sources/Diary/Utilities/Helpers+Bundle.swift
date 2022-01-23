//
//  Helpers+Bundle.swift
//  
//
//  Created by Danny Gilbert on 1/22/22.
//

import Foundation

public extension Helpers {
    
    struct BundleKey {
        static let appBuild: AnyKey = "CFBundleVersion"
        static let appVersion: AnyKey = "CFBundleShortVersionString"
        static let name: AnyKey = "CFBundleName"
        static let displayName: AnyKey = "CFBundleDisplayName"
    }
}

func bundleInfo(
    for key: AnyKey,
    in bundle: Bundle = .main
) -> Any? {
    bundle.infoDictionary?[key.stringValue]
}
