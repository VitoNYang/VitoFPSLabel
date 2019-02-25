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
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange(notification:)), name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func orientationDidChange(notification: Notification) {
        var fpsFrame = self.fpsWindow.frame
        check(frame: &fpsFrame)
        self.fpsWindow.frame = fpsFrame
    }
    
    private weak var panGesture: UIPanGestureRecognizer?
    
    
    /// 用来控制 FPS label 能否拖动, true 代表可以拖动, false 代表不可以拖动
    public var needDrag = false {
        didSet {
            guard needDrag != oldValue else { return }
            
            if needDrag {
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandle(panGesture:)))
                fpsWindow.addGestureRecognizer(panGesture)
                self.panGesture = panGesture
            } else {
                guard let pan = panGesture else { return }
                fpsWindow.removeGestureRecognizer(pan)
            }
        }
    }
    
    fileprivate lazy var fpsWindow: UIWindow = {
        let window = UIWindow()
        window.windowLevel = UIWindow.Level.statusBar + 1
        window.backgroundColor = .clear
        window.addSubview(self.fpsLabel)
        
        func rootViewController() -> UIViewController {
            let VC = UIViewController()
            VC.view.backgroundColor = .clear
            return VC
        }
        
        window.rootViewController = rootViewController()
        
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
    
    /// 调用这个方法来显示 VitoFPSLabel
    public func show() {
        fpsWindow.isHidden = false
        fpsLabel.isTracking = true
    }
    
    /// 调用这个方法来隐藏 VitoFPSLabel
    public func hidden() {
        fpsWindow.isHidden = true
        fpsLabel.isTracking = false
    }
    
    @objc func panHandle(panGesture: UIPanGestureRecognizer) {
        let position = panGesture.translation(in: panGesture.view)
        panGesture.setTranslation(.zero, in: panGesture.view)
        var fpsFrame = fpsWindow.frame
        let newOrigin = fpsFrame.origin + position
        fpsFrame.origin = newOrigin
        check(frame: &fpsFrame)
        fpsWindow.frame = fpsFrame
    }
}

/// 用来修正 CGRect, 避免 frame 超出屏幕
func check(frame: inout CGRect) {
    let screenBounds = UIScreen.main.bounds
    frame.origin.x = max(min(screenBounds.width - frame.width, frame.origin.x), 0)
    frame.origin.y = max(min(screenBounds.height - frame.height, frame.origin.y), 0)
}

/// 用来把两个 CGPoint 相加
func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint{
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

extension VitoFPSManager: VitoFPSLabelDelegate {
    public func sizeDidChange(newSize: CGSize) {
        fpsWindow.frame = CGRect(origin: fpsWindow.frame.origin, size: newSize)
    }
}
