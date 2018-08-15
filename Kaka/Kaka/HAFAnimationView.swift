//
//  HAFAnimationView.swift
//  Kaka
//
//  Created by Jovi on 8/8/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFAnimationView: NSView {
    private var _kakaObj: HAFKakaObject?
    private var _timer: DispatchSourceTimer?
    private var _currentFrame: NSImage?
    
    override init(frame frameRect: NSRect) {
        _kakaObj = nil
        super.init(frame: frameRect)
    }

    required init?(coder decoder: NSCoder) {
        _kakaObj = nil
        super.init(coder: decoder)
    }
    
    public func setKakaObj(_ kakaObj: HAFKakaObject){
        _kakaObj = kakaObj
    }
    
    public func startToPlay(){
        _timer = DispatchSource.makeTimerSource(queue: .main)
        _timer?.schedule(wallDeadline: .now(), repeating: .milliseconds(58), leeway: .milliseconds(1))
        _timer?.setEventHandler {
            if nil != self._kakaObj{
                self._currentFrame = self._kakaObj!.currentAnimationFrame()
                self.setNeedsDisplay(self.bounds)
                self._kakaObj!.moveToNextAnimationFrame()
            }
            
        }
        _timer?.resume()
    }
    
    public func stopPlaying(){
        _timer?.cancel()
        _timer = nil
    }
    
    override func draw(_ dirtyRect: NSRect) {
//        super.draw(dirtyRect)
        // Drawing code here.
        NSColor.clear.set()
        self.frame.fill()
        if nil != _currentFrame {
            _currentFrame!.draw(at: NSZeroPoint, from: NSZeroRect, operation: NSCompositingOperation.sourceOver, fraction: 1.0)
        }
    }
}
