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
    
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: .borderless, backing: .buffered, defer: false)
        self.alphaValue = 1.0
        self.isOpaque = false
        self.level = NSWindow.Level(Int(CGWindowLevelForKey(.statusWindow) + 1))
    }
    
    override var canBecomeKey: Bool{
        return true
    }
    
    override func mouseDown(with event: NSEvent) {
        ptOldLocation = event.locationInWindow
    }
    
    override func mouseDragged(with event: NSEvent) {
        let rctScreenVisibleFrame = NSScreen.main?.frame
        if nil == rctScreenVisibleFrame {
            return;
        }
        let rctWindowFrame = self.frame
        
        var ptNewOrigin = rctWindowFrame.origin
        let ptCurrentLocation = event.locationInWindow
        
        ptNewOrigin.x += (ptCurrentLocation.x - ptOldLocation.x);
        ptNewOrigin.y += (ptCurrentLocation.y - ptOldLocation.y);
        
        if (ptNewOrigin.y + rctWindowFrame.size.height) > (rctScreenVisibleFrame!.origin.y + rctScreenVisibleFrame!.size.height + 33){
            ptNewOrigin.y = rctScreenVisibleFrame!.origin.y + (rctScreenVisibleFrame!.size.height - rctWindowFrame.size.height + 33);
        }
        
        if (ptNewOrigin.x + rctWindowFrame.size.width) > (rctScreenVisibleFrame!.origin.x + rctScreenVisibleFrame!.size.width) {
            ptNewOrigin.x = rctScreenVisibleFrame!.origin.x + (rctScreenVisibleFrame!.size.width - rctWindowFrame.size.width);
        }
        
        self.setFrameOrigin(ptNewOrigin)
    }
}
