//
//  HAFAnimationView.swift
//  Kaka
//
//  Created by Jovi on 8/8/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFAnimationView: NSView {
    private var animationSequence: HAFAnimationSequence?
    private var frameIndex: Int
    private var currentFrame: NSImage?
    private var timer: DispatchSourceTimer?
    
    override init(frame frameRect: NSRect) {
        animationSequence = nil
        frameIndex = 0
        currentFrame = nil
        super.init(frame: frameRect)
    }

    required init?(coder decoder: NSCoder) {
        animationSequence = nil
        frameIndex = 0
        currentFrame = nil
        super.init(coder: decoder)
    }
    
    public func setAnimationSequence(_ AnimSeq: HAFAnimationSequence){
        frameIndex = 0
        animationSequence = AnimSeq
    }
    
    public func startToPlay(){
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(wallDeadline: .now(), repeating: .milliseconds(44), leeway: .milliseconds(1))
        timer?.setEventHandler {
            if nil != self.animationSequence{
                self.frameIndex = self.frameIndex >= self.animationSequence!.frameCount() ? 0 : self.frameIndex;
                self.currentFrame = self.animationSequence?.frameAtIndex(self.frameIndex)
                self.setNeedsDisplay(self.bounds)
                self.frameIndex += 1
            }
            
        }
        timer?.resume()
    }
    
    public func stopPlaying(){
        timer?.cancel()
        timer = nil
    }
    
    override func draw(_ dirtyRect: NSRect) {
//        super.draw(dirtyRect)
        // Drawing code here.
        NSColor.clear.set()
        self.frame.fill()
        if nil != currentFrame {
            currentFrame!.draw(at: NSZeroPoint, from: NSZeroRect, operation: NSCompositingOperation.sourceOver, fraction: 1.0)
        }
    }
}
