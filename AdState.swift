//
//  SDKConfig.swift
//  AdSource
//
//  Created by Sanchita Das Gupta on 10/07/23.
//

import Foundation

public protocol IntRawRepresentable: RawRepresentable {
    var rawValue: Int { get }
}

public protocol StateProtocol: IntRawRepresentable, Hashable {}

extension StateProtocol {
   public var hashValue: Int {
        return rawValue
    }
}

public class BasicStateMachine<T: StateProtocol> {
    private var state: T
    let dispatchQueue: DispatchQueue
    let initialState: T
    var allowTransitionToInitialState: Bool
    var onStateChange: ((T) -> Void)?
    
    public init(initialState: T, allowTransitionToInitialState: Bool = true) {
        self.state = initialState
        self.initialState = initialState
        self.allowTransitionToInitialState = allowTransitionToInitialState
        self.dispatchQueue = DispatchQueue(label: "\(String(describing: type(of: self)))")
    }
    
    public func getState() -> T {
        return self.dispatchQueue.sync {
            return self.state
        }
    }
    
    public func set(state: T) {
        self.dispatchQueue.sync {
            if state == self.initialState && !self.allowTransitionToInitialState {
                return
            }
            if self.state != state {
                self.state = state
                DispatchQueue.main.async {
                    self.onStateChange?(state)
                }
            }
        }
    }
    
    public func reset() {
        dispatchQueue.sync {
            self.state = self.initialState
            DispatchQueue.main.async {
                self.onStateChange?(self.state)
            }
        }
    }
}

