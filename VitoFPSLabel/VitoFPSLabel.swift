//
//  VitoFPSLabel.swift
//  VitoFPS
//
//  Created by hao on 2017/3/13.
//  Copyright © 2017年 Vito. All rights reserved.
//

import UIKit

open class VitoFPSLabel: UILabel {
    
    private var displayLink: CADisplayLink?
    private var count = 0
    private var lastTime: CFTimeInterval = 0
    /// 是否开启检测 FPS
    var isTracking = true {
        didSet {
            if isTracking { startFPSTrack() }
            else { pauseFPSTrack() }
        }
    }
    
    public var topAndBottomPadding: CGFloat = 0
    public var leftAndRightPadding: CGFloat = 10
    
    public weak var fpsDelegate: VitoFPSLabelDelegate?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    deinit {
        print("VitoFPSLabel deinit")
        stopTicking()
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterBackground(notification:)), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBecomeActive(notification:)), name: .UIApplicationDidBecomeActive, object: nil)
        displayLink = CADisplayLink(target: VitoFPSProxy(target: self), selector: #selector(VitoFPSProxy.callback(displayLink:)))
        displayLink?.add(to: .main, forMode: .commonModes)
        
        backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        textAlignment = .center
        text = ""
        isHidden = true
    }
    
    func startFPSTrack() {
        if isTracking {
            displayLink?.isPaused = false
        }
    }
    
    func pauseFPSTrack() {
        displayLink?.isPaused = true
    }
    
    @objc fileprivate func handleEnterBackground(notification: Notification)
    {
        pauseFPSTrack()
    }
    
    @objc fileprivate func handleBecomeActive(notification: Notification)
    {
        startFPSTrack()
    }
    
    /*
     思路: 计算一秒内, 回调被调用了多少次
     */
    fileprivate func callback(link: CADisplayLink)
    {
        let currentTimestamp = link.timestamp
        guard lastTime != 0 else {
            lastTime = currentTimestamp
            return
        }
        
        // 每调用一次加 1
        count += 1
        
        let timeOffset = currentTimestamp - lastTime
        if timeOffset < 1 { return }
        
        // fps = 回调次数 / 使用的时间
        let fps = Double(count) / timeOffset
        
        // 重置计数器
        count = 0
        // 重置时间戳
        lastTime = currentTimestamp
        
        self.text = String(format: "%.2f FPS", fps)
        if isHidden {
            isHidden = false
        }
        
        invalidateIntrinsicContentSize()
    }
    
    override open var intrinsicContentSize: CGSize
    {
        let size = super.intrinsicContentSize
        let newSize = CGSize(width: size.width + leftAndRightPadding, height: size.height + topAndBottomPadding)
        fpsDelegate?.sizeDidChange(newSize: newSize)
        return newSize
    }
    
    private func stopTicking()
    {
        pauseFPSTrack()
        displayLink?.invalidate()
        displayLink = nil
    }
}

public protocol VitoFPSLabelDelegate : NSObjectProtocol
{
    /// 用来监听 VitoFPSLabel size 的变化
    func sizeDidChange(newSize: CGSize)
}

/*
 用来防止循环引用
 */
class VitoFPSProxy {
    weak var target: VitoFPSLabel?
    init(target: VitoFPSLabel) {
        self.target = target
    }
    
    @objc func callback(displayLink: CADisplayLink) {
        target?.callback(link: displayLink)
    }
}
