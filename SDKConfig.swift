//
//  SDKConfig.swift
//  AdSource
//
//  Created by Sanchita Das Gupta on 10/07/23.
//

import Foundation
import GoogleInteractiveMediaAds
import MaasSDKFramework
@objc public class SDKConfig: NSObject {
    
    static let shared = SDKConfig()

    private override init() {}
    
    @objc public var adTagUrl: String = ""
    @objc public var adsResponse: String = ""
    
    @objc public let enableBackgroundPlayback = true
    @objc public let autoPlayAdBreaks = false
    @objc public var playerType: String = "AVPlayer"
    @objc public var alwaysStartWithPreroll: Bool = false
    @objc public var companionView: UIView?
    @objc public var webOpenerPresentingController: UIViewController?
    
    public var playerView: AVPlayer?
    public var contentView: UIView?
    public var stateMachine = BasicStateMachine(initialState: ADState.start, allowTransitionToInitialState: false)
    
    private var imaPlugin: IMAPlugin?

    private var currentSDK: SDKSupport?
    
    @discardableResult
    @nonobjc public func set(adTagUrl: String) -> Self {
        self.adTagUrl = adTagUrl
        return self
    }
    
    func fetchCurrentSDK(state: SDKSupport) {
        
        currentSDK = state
        switch state {
            
        case .GoogleBanner:
            print("Initialize Banner Ads")
            
        case .GoogleIMA:
            imaPlugin = IMAPlugin(playerView: contentView!, contentPlayer:playerView!)
            imaPlugin?.requestAds()
        }
    }
    
    func handlePlayerState(state: PlayerState) {
        
        switch currentSDK {
        case .GoogleBanner:
            print("onPlayPauseHandle")
        case .GoogleIMA:
            imaPlugin?.handlePlayerState(state: state)
        default :
            break
        }
        
    }
}
