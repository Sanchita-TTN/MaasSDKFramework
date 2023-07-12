//
//  IMAPlugin.swift
//  AdSource
//
//  Created by Sanchita Das Gupta on 11/07/23.
//

import Foundation
import GoogleInteractiveMediaAds
import AVFoundation


public class IMAPlugin: NSObject, IMAContentPlayhead, AVPictureInPictureControllerDelegate {
    public var currentTime: TimeInterval = 0.0
    
    
    private static var loader: IMAAdsLoader!
    private var adsManager: IMAAdsManager?
    private var renderingSettings: IMAAdsRenderingSettings! = IMAAdsRenderingSettings()
    private var playerView: UIView
    private var contentPlayer: AVPlayer
    
    private var adDisplayContainer: IMAAdDisplayContainer?
    private var pictureInPictureProxy: IMAPictureInPictureProxy?
    
    private var contentEndedNeedToPlayPostroll: Bool = false
    
    init(playerView: UIView, contentPlayer: AVPlayer) {
        self.playerView = playerView
        self.contentPlayer = contentPlayer
        super.init()
        self.createLoader()
    }
    
    private func createLoader() {
        self.setupLoader(with: SDKConfig.shared)
        IMAPlugin.loader.delegate = self
    }
    
    private func setupLoader(with config: SDKConfig) {
        let imaSettings: IMASettings! = IMASettings()
        imaSettings.enableBackgroundPlayback = config.enableBackgroundPlayback
        imaSettings.autoPlayAdBreaks = config.autoPlayAdBreaks
        imaSettings.playerType = config.playerType
        IMAPlugin.loader = IMAAdsLoader(settings: imaSettings)
    }
    
    public func requestAds() {
        
        if SDKConfig.shared.adTagUrl.isEmpty && SDKConfig.shared.adsResponse.isEmpty {
            print("adTagUrl empty")
        }
        
        pictureInPictureProxy = IMAPictureInPictureProxy(avPictureInPictureControllerDelegate: self)
        
        let request = IMAAdsRequest(
            adTagUrl: SDKConfig.shared.adTagUrl,
            adDisplayContainer: createAdDisplayContainer(),
            avPlayerVideoDisplay: IMAAVPlayerVideoDisplay(avPlayer: contentPlayer), pictureInPictureProxy: pictureInPictureProxy!,
            userContext: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentDidFinishPlaying(_:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: contentPlayer.currentItem)
        
        
        if IMAPlugin.loader == nil {
            self.createLoader()
        }
        
        IMAPlugin.loader.requestAds(with: request)
    }
    
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        if (notification.object as? AVPlayerItem) == contentPlayer.currentItem {
            IMAPlugin.loader.contentComplete()
        }
    }
    
    
    func createAdDisplayContainer() -> IMAAdDisplayContainer {
        
        return IMAAdDisplayContainer(
            adContainer: playerView, viewController: playerView.findViewController(), companionSlots: nil)
    }
    
    public var isAdPlaying: Bool {
        return adsManager?.adPlaybackInfo.isPlaying ?? (SDKConfig.shared.stateMachine.getState() == .adsPlaying)
    }
    
    public var startWithPreroll: Bool {
        return SDKConfig.shared.alwaysStartWithPreroll
    }
    
    public func handlePlayerState(state: PlayerState) {
        switch state {
        case .play:
            self.adsManager?.resume()
            
        case .pause:
            self.adsManager?.pause()
            
        case .completed:
            self.contentComplete()
        default:
            break
        }
    }
 
    public func contentComplete() {
        IMAPlugin.loader?.contentComplete()
    }
    
    public func destroyManager() {
        self.adsManager?.delegate = nil
        self.adsManager?.destroy()
        self.contentComplete()
        self.adsManager = nil
        SDKConfig.shared.stateMachine.reset()
    }
}


extension IMAPlugin : IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    public func adsManager(_ adsManager: IMAAdsManager, didReceive event: IMAAdEvent) {
        print("AdsManager event \(event.typeString)")
        switch event.type {
        case IMAAdEventType.LOADED:
            adsManager.start()
            break
            
        case IMAAdEventType.PAUSE:
            break
            
        case IMAAdEventType.RESUME:
            break
            
        case IMAAdEventType.COMPLETE:
            SDKConfig.shared.stateMachine.set(state: .contentPlaying)
        case IMAAdEventType.TAPPED:
            break
            
        case IMAAdEventType.ALL_ADS_COMPLETED:
            self.destroyManager()
        default:
            break
        }
    }
    
    public func adsLoader(_ loader: IMAAdsLoader, adsLoadedWith adsLoadedData: IMAAdsLoadedData) {
        self.adsManager = adsLoadedData.adsManager
        self.adsManager?.delegate = self
        
        let adsRenderingSettings = IMAAdsRenderingSettings()
        adsRenderingSettings.linkOpenerPresentingController = SDKConfig.shared.webOpenerPresentingController
        
        self.adsManager?.initialize(with: adsRenderingSettings)
    }
    
    public func adsLoader(_ loader: IMAAdsLoader, failedWith adErrorData: IMAAdLoadingErrorData) {
        contentPlayer.play()
    }
    
    public func adsManager(_ adsManager: IMAAdsManager, didReceive error: IMAAdError) {
        contentPlayer.play()
    }
    
    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager) {
        contentPlayer.pause()
    }
    
    public func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {
        contentPlayer.play()
    }
    
}
    


extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
