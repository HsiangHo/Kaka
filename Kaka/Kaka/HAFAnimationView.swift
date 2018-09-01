//
//  HAFAnimationView.swift
//  Kaka
//
//  Created by Jovi on 8/8/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa
import AVFoundation

@objc protocol HAFAnimationViewDelegate {
    @objc optional func leftButtonClick()
    @objc optional func rightButtonClick() -> Void
    @objc optional func doubleClick() -> Void
}

class HAFAnimationView: NSView {
    private var _kakaObj: HAFKakaObject?
    private var _timer: DispatchSourceTimer?
    private var _currentFrame: NSImage?
    private var _doubleClickTimer: Timer?
    var actionMenu: NSMenu?
    weak var delegate: HAFAnimationViewDelegate?
    var audioPlayer: AVAudioPlayer?
    
    override init(frame frameRect: NSRect) {
        _kakaObj = nil
        actionMenu = nil
        delegate = nil
        audioPlayer = nil
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
                self.playAudio(audioUrl: self._kakaObj!.currentAnimationAudio())
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
    
    override func mouseUp(with event: NSEvent) {
        if event.clickCount > 1 {
            _doubleClickTimer?.invalidate()
            onDoubleClick(with: event)
        } else if event.clickCount == 1 {
            _doubleClickTimer = Timer.scheduledTimer(timeInterval: 0.3, target:self, selector: #selector(onClickTimeout(_:)), userInfo: nil, repeats: false)
        }
    }
    
    @objc func onClickTimeout(_ timer: Timer) {
        _kakaObj!.doAction(actionType: .eLeftBtnClick, clearFlag: true)
        if nil != delegate?.leftButtonClick {
            delegate?.leftButtonClick!()
        }
    }
    
    override func rightMouseUp(with event: NSEvent) {
        _kakaObj!.doAction(actionType: .eRightBtnClick, clearFlag: true)
        if nil != delegate?.rightButtonClick {
            delegate?.rightButtonClick!()
        }
    }
    
    func onDoubleClick(with event: NSEvent) -> Void {
        _kakaObj!.doAction(actionType: .eDoubleClick, clearFlag: true)
        //Show desktop
        if nil != delegate?.doubleClick {
            delegate?.doubleClick!()
        }
    }
    
    override func menu(for event: NSEvent) -> NSMenu? {
        return actionMenu
    }
    
    override func draw(_ dirtyRect: NSRect) {
        // Drawing code here.
        NSColor.clear.set()
        self.frame.fill()
        if nil != _currentFrame {
            _currentFrame!.draw(at: NSZeroPoint, from: NSZeroRect, operation: NSCompositingOperation.sourceOver, fraction: 1.0)
        }
    }
    
    //MARK: Private methods
    
    func playAudio(audioUrl: URL?) -> Void {
        if nil == audioUrl {
            return
        }
        do {
            let sound = try AVAudioPlayer(contentsOf: audioUrl!)
            audioPlayer = sound
            audioPlayer?.play()
        } catch {
            //
        }
    }
}
