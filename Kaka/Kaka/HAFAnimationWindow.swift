//
//  HAFAnimationWindow.swift
//  Kaka
//
//  Created by Jovi on 8/19/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFAnimationWindow: NSWindow {
    var ptOldLocation: NSPoint = NSZeroPoint
    var draggingAreaFunc: (() -> NSRect?)?
    var draggingCompletedFunc: ((NSRect) -> Void)?

    func setDraggingCallback(areaFunc: @escaping () -> NSRect?, completedFunc: @escaping (NSRect) -> Void) -> Void {
        draggingAreaFunc = areaFunc
        draggingCompletedFunc = completedFunc
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: .borderless, backing: .buffered, defer: false)
        self.alphaValue = 1.0
        self.isOpaque = false
        self.level = NSWindow.Level(Int(CGWindowLevelForKey(.statusWindow) + 1))
        self.backgroundColor = NSColor.clear
    }
    
    override var canBecomeKey: Bool{
        return true
    }
    
    override func mouseDown(with event: NSEvent) {
        ptOldLocation = event.locationInWindow
    }
    
    override func mouseDragged(with event: NSEvent) {
        if nil == draggingAreaFunc{
            return
        }
        let rctScreenFrame = draggingAreaFunc!()
        if nil == rctScreenFrame {
            return;
        }
        let rctWindowFrame = self.frame
        
        var ptNewOrigin = rctWindowFrame.origin
        let ptCurrentLocation = event.locationInWindow
        
        ptNewOrigin.x += (ptCurrentLocation.x - ptOldLocation.x);
        ptNewOrigin.y += (ptCurrentLocation.y - ptOldLocation.y);
        
        if (ptNewOrigin.y + rctWindowFrame.size.height) > (rctScreenFrame!.origin.y + rctScreenFrame!.size.height) {
            ptNewOrigin.y = rctScreenFrame!.origin.y + (rctScreenFrame!.size.height - rctWindowFrame.size.height);
        }
        
        if (ptNewOrigin.x + rctWindowFrame.size.width) > (rctScreenFrame!.origin.x + rctScreenFrame!.size.width) {
            ptNewOrigin.x = rctScreenFrame!.origin.x + (rctScreenFrame!.size.width - rctWindowFrame.size.width);
        }
        
        self.setFrameOrigin(ptNewOrigin)
        if nil != draggingCompletedFunc{
            let rctRslt = NSMakeRect(ptNewOrigin.x, ptNewOrigin.y, rctWindowFrame.size.width, rctWindowFrame.size.height)
            draggingCompletedFunc!(rctRslt)
        }
    }
}
