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
    var actionMenu: NSMenu!
    var menuItemAbout: NSMenuItem!
    var menuItemPreferences: NSMenuItem!
    var menuItemShowDesktop: NSMenuItem!
    var menuItemShowDesktopIcon: NSMenuItem!
    var menuItemQuit: NSMenuItem!
    let aboutWindowController: HAFAboutWindowController? = HAFAboutWindowController.init()
    let preferencesWindowController: HAFPreferencesWindowController? = HAFPreferencesWindowController.init()
    
    init() {
        var offsetX: CGFloat = 0
        if nil != NSScreen.main {
            offsetX = NSScreen.main!.frame.width - 120
        }
        let windowFrame = NSMakeRect(offsetX, 0, 215, 170)
        let frame = NSMakeRect(0, 0, NSWidth(windowFrame), NSHeight(windowFrame))
        let wnd = HAFAnimationWindow.init(contentRect: windowFrame, styleMask: .borderless, backing: .buffered, defer: false)
        wnd.contentView = HAFTransparentView.init(frame: frame)
        _view = HAFAnimationView.init(frame: frame)
        wnd.contentView?.addSubview(_view)
        actionMenu = NSMenu.init(title: "actionMenu")
        menuItemAbout = NSMenuItem.init(title: NSLocalizedString("About", comment: ""), action: #selector(aboutMenuItem_click), keyEquivalent: "")
        menuItemPreferences = NSMenuItem.init(title: NSLocalizedString("Preferences", comment: ""), action: #selector(preferencesMenuItem_click), keyEquivalent: ",")
        menuItemShowDesktop = NSMenuItem.init(title: NSLocalizedString("Show Desktop", comment: ""), action: #selector(showDesktopMenuItem_click), keyEquivalent: "")
        menuItemShowDesktopIcon = NSMenuItem.init(title: NSLocalizedString("Show/Hide Desktop Icons", comment: ""), action: #selector(showDesktopIconMenuItem_click), keyEquivalent: "")
        menuItemQuit = NSMenuItem.init(title: NSLocalizedString("Quit", comment: ""), action: #selector(quit_click), keyEquivalent: "")
        super.init(window: wnd)
        actionMenu.insertItem(menuItemAbout, at: 0)
        actionMenu.insertItem(menuItemPreferences, at: 1)
        actionMenu.insertItem(menuItemShowDesktop, at: 2)
        actionMenu.insertItem(menuItemShowDesktopIcon, at: 3)
        actionMenu.insertItem(menuItemQuit, at: 4)
        _view.delegate = self
        _view.actionMenu = actionMenu
        wnd.setDraggingCallback(areaFunc: draggingArea, completedFunc: draggingCompleted)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: kakaObject
    
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
    
    //MARK: HAFAnimationViewDelegate callback
    
    func leftButtonClick() -> Void{
        if HAFConfigureManager.sharedManager.isOneClickToHideDesktopIcons() {
            __showDesktopIcons()
        }
    }
    
    func doubleClick() -> Void{
        if HAFConfigureManager.sharedManager.isDoubleClickToShowDesktop() {
            __showDesktop()
        }
    }
    
    //MARK: IBActions
    
    @IBAction func aboutMenuItem_click(sender: AnyObject?){
        aboutWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func preferencesMenuItem_click(sender: AnyObject?){
        preferencesWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func showDesktopMenuItem_click(sender: AnyObject?){
        __showDesktop()
    }
    
    @IBAction func showDesktopIconMenuItem_click(sender: AnyObject?){
        __showDesktopIcons()
    }
    
    @IBAction func quit_click(sender: AnyObject?){
        NSApplication.shared.terminate(nil)
    }
    
    //MARK: Private functions
    func __showDesktop() -> Void {
        SSDesktopManager.shared().showDesktop(false)
    }
    
    func __showDesktopIcons() -> Void {
        //Desktop cover
        if SSDesktopManager.shared().desktopCoverWindow().isVisible{
            SSDesktopManager.shared().uncoverDesktop()
        }else{
            SSDesktopManager.shared().desktopCoverImageView().image = SSDesktopManager.path2image(SSDesktopManager.shared().desktopBackgroundImagePath())
            SSDesktopManager.shared().coverDesktop()
        }
    }
}
