//
//  VitoFPSLabel.swift
//  VitoFPS
//
//  Created by hao on 2017/3/13.
//  Copyright © 2017年 Vito. All rights reserved.
//

import UIKit

open class VitoFPSLabel: UILabel {
    
    var displayLink: CADisplayLink?
    var count = 0
    var lastTime: CFTimeInterval = 0
    
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
        displayLink = CADisplayLink(target: VitoFPSProxy(target: self), selector: #selector(VitoFPSProxy.callback(displayLink:)))
        displayLink?.add(to: .main, forMode: .commonModes)
        backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        textAlignment = .center
        text = "60 FPS"
    }
    
    /*
     思路: 计算一秒内, 回调被调用了多少次
     */
    fileprivate func callback(link: CADisplayLink) {
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
        invalidateIntrinsicContentSize()
    }
    
    override open var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        return CGSize(width: size.width + 16, height: size.height + 10)
    }
    
    private func stopTicking() {
        displayLink?.invalidate()
        displayLink = nil
    }
}

class VitoFPSProxy {
    weak var target: VitoFPSLabel?
    init(target: VitoFPSLabel) {
        self.target = target
    }
    
    @objc func callback(displayLink: CADisplayLink) {
        target?.callback(link: displayLink)
    }
}
