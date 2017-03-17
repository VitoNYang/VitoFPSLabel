//
//  VitoFPSManager.swift
//  VitoFPS
//
//  Created by hao Mac Mini on 2017/3/17.
//  Copyright © 2017年 Vito. All rights reserved.
//

import UIKit

open class VitoFPSManager: NSObject {
    public static let shared = VitoFPSManager()
    private override init() {}
    
    fileprivate lazy var fpsWindow: UIWindow = {
        let window = UIWindow()
        window.windowLevel = UIWindowLevelStatusBar + 1
        window.backgroundColor = .clear
        window.addSubview(self.fpsLabel)
        
        window.rootViewController = UIViewController()
        
        self.fpsLabel.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        self.fpsLabel.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        self.fpsLabel.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        self.fpsLabel.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
        
        return window
    }()
    
    lazy var fpsLabel: VitoFPSLabel = {
        let fpsLabel = VitoFPSLabel()
        fpsLabel.translatesAutoresizingMaskIntoConstraints = false
        fpsLabel.fpsDelegate = self
        return fpsLabel
    }()
    
    public func show() {
        fpsWindow.isHidden = false
    }
    
    public func hidden() {
        fpsWindow.isHidden = true
    }
}

extension VitoFPSManager: VitoFPSLabelDelegate {
    public func sizeDidChange(newSize: CGSize) {
        fpsWindow.frame = CGRect(origin: fpsWindow.frame.origin, size: newSize)
    }
}
