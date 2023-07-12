//
//  Constant.swift
//  AdSource
//
//  Created by Sanchita Das Gupta on 11/07/23.
//

import Foundation

enum SDKSupport {
    case GoogleIMA
    case GoogleBanner
}

 public enum ADState: Int, CustomStringConvertible, StateProtocol {
    case start = 0
    case startAndRequest
    case adsRequested
    case adsRequestedAndPlay
    case adsRequestFailed
    case adsRequestTimedOut
    case adsLoaded
    case adsLoadedAndPlay
    case adsPlaying
    case contentPlaying
    
    public var description: String {
        switch self {
        case .start: return "Start"
        case .startAndRequest: return "StartAndRequest"
        case .adsRequested: return "AdsRequested"
        case .adsRequestedAndPlay: return "AdsRequestedAndPlay"
        case .adsRequestFailed: return "AdsRequestFailed"
        case .adsRequestTimedOut: return "AdsRequestTimedOut"
        case .adsLoaded: return "AdsLoaded"
        case .adsLoadedAndPlay: return "AdsLoadedAndPlay"
        case .adsPlaying: return "AdsPlaying"
        case .contentPlaying: return "contentPlaying"
        }
    }
}

public enum PlayerState: CustomStringConvertible {
    case play, pause, discard, skipped, completed
    
    public var description: String {
        switch self {
        case .play:
            return "Play"
        case .pause:
            return "pause"
        case .discard:
            return "discard"
        case .skipped:
            return "skipped"
        case .completed:
            return "completed"
        }
    }
}
