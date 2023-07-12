//
//  MaasSDKConfig.swift
//  MaasSDKFramework
//
//  Created by Sanchita Das Gupta on 12/07/23.
//

import Foundation
public class SDKConfig {
    
    static let shared = SDKConfig()
    
    private init() {}
    
    public static func doSomething() -> String {
        return "Hello name"
    }
    
}
