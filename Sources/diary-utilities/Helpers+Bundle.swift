//
//  Helpers+Bundle.swift
//  
//
//  Created by Danny Gilbert on 1/22/22.
//

import Foundation

public extension Helpers {
    
    struct BundleKey {
        public static let appBuild: AnyKey = "CFBundleVersion"
        public static let appVersion: AnyKey = "CFBundleShortVersionString"
        public static let name: AnyKey = "CFBundleName"
        public static let displayName: AnyKey = "CFBundleDisplayName"
    }
    
    static func bundleInfo(
        for key: AnyKey,
        in bundle: Bundle = .main
    ) -> Any? {
        bundle.infoDictionary?[key.stringValue]
    }
}
