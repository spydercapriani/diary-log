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
            let value = bundleInfo(for: Helpers.BundleKey.displayName) ?? bundleInfo(for: Helpers.BundleKey.name)
            return value as? String
        }()
        
        guard
            let build = bundleInfo(for: Helpers.BundleKey.appBuild) as? String,
            let version = bundleInfo(for: Helpers.BundleKey.appVersion) as? String,
            let name = appName
        else { return nil }
        self.build = build
        self.name = name
        self.version = version
    }
}
