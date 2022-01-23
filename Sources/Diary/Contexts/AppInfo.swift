//
//  AppInfo.swift
//  
//
//  Created by Danny Gilbert on 1/22/22.
//

import Foundation

public struct AppInfo: Context {
    let build: String
    let name: String
    let version: String
}

// MARK: - Initializers
public extension AppInfo {
    
    init?() {
        let appName: String? = {
            let value = Helpers.bundleInfo(for: Helpers.BundleKey.displayName) ?? Helpers.bundleInfo(for: Helpers.BundleKey.name)
            return value as? String
        }()
        
        guard
            let build = Helpers.bundleInfo(for: Helpers.BundleKey.appBuild) as? String,
            let version = Helpers.bundleInfo(for: Helpers.BundleKey.appVersion) as? String,
            let name = appName
        else { return nil }
        self.build = build
        self.name = name
        self.version = version
    }
}
