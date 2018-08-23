//
//  HAFKakaWindowController.swift
//  Kaka
//
//  Created by Jovi on 8/19/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFKakaWindowController: NSWindowController, HAFAnimationViewDelegate {
    var _view: HAFAnimationView!
    var _kakaObj: HAFKakaObject? = nil
    
    init() {
        let frame = NSMakeRect(0, 0, 215, 170)
        let wnd = HAFAnimationWindow.init(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
        wnd.contentView = HAFTransparentView.init(frame: frame)
        _view = HAFAnimationView.init(frame: frame)
        wnd.contentView?.addSubview(_view)
        super.init(window: wnd)
        _view.delegate = self as! HAFAnimationViewDelegate
        wnd.setDraggingCallback(areaFunc: draggingArea, completedFunc: draggingCompleted)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setKakaObject(kakaObj: HAFKakaObject) -> Void {
        _kakaObj = kakaObj
        _kakaObj?.setAnimationView(_view)
    }
    
    func draggingArea() -> NSRect {
        var rctArea: NSRect? = NSScreen.main?.frame
        if nil == rctArea {
            return NSZeroRect
        }
        switch _kakaObj!._state {
            case .eKakaStateNormal:
                rctArea!.size.width += 105;
                rctArea!.size.height += 45;
            break
            
            case .eKakaStateHidden:
                rctArea!.size.height += 32;
            break
            
            case .eKakaStateDragging:
                rctArea!.size.width += 105;
                rctArea!.size.height += 33;
            break
        }
        return rctArea!
    }
    
    func draggingCompleted(rctFrame: NSRect) -> Void {
        let rctArea: NSRect? = NSScreen.main?.frame
        if nil == rctArea {
            return
        }
        switch _kakaObj!._state {
        case .eKakaStateNormal:
            if NSMaxX(rctFrame) - NSMaxX(rctArea!) >= 105{
                _kakaObj!.doAction(actionType: .eDragToRightMargin, clearFlag: true)
                _kakaObj!.skipCurrentAnimationSequenceChain()
            }else if NSMaxY(rctFrame) - NSMaxY(rctArea!) >= 33{
                _kakaObj!.doAction(actionType: .eDragToTopMargin, clearFlag: false)
            }
            break
            
        case .eKakaStateHidden:
            if NSMaxX(rctFrame) < NSMaxX(rctArea!){
                _kakaObj!.doAction(actionType: .eDragFromRightMargin, clearFlag: true)
                _kakaObj!.skipCurrentAnimationSequenceChain()
            }else if NSMaxY(rctFrame) - NSMaxY(rctArea!) >= 33{
                _kakaObj!.doAction(actionType: .eDragToTopMargin, clearFlag: false)
            }
            break
            
        case .eKakaStateDragging:
            if NSMaxX(rctFrame) - NSMaxX(rctArea!) >= 105{
                _kakaObj!.doAction(actionType: .eDragToRightMargin, clearFlag: true)
                _kakaObj!.skipCurrentAnimationSequenceChain()
            }else if NSMaxY(rctFrame) - NSMaxY(rctArea!) < 33{
                _kakaObj!.doAction(actionType: .eDragFromTopMargin, clearFlag: false)
            }
            break
        }
    }
    
    func leftButtonClick() -> Void{
        //Desktop cover
        if SSDesktopManager.shared().desktopCoverWindow().isVisible{
            SSDesktopManager.shared().uncoverDesktop()
        }else{
            SSDesktopManager.shared().desktopCoverImageView().image = SSDesktopManager.path2image(SSDesktopManager.shared().desktopBackgroundImagePath())
            SSDesktopManager.shared().coverDesktop()
        }
    }
    
    func doubleClick() -> Void{
        SSDesktopManager.shared().showDesktop(false)
    }
}
