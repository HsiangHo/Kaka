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
    var menuItemPreventSystemSleep: NSMenuItem!
    var menuItemAutoHideMouseCursor: NSMenuItem!
    var menuItemAutoHideDesktopIcons: NSMenuItem!
    var menuItemRateOnMacAppStore: NSMenuItem!
    var menuItemDisplayKaka: NSMenuItem!
    var menuItemAbout: NSMenuItem!
    var menuItemPreferences: NSMenuItem!
    var menuItemShowDesktop: NSMenuItem!
    var menuItemShowDesktopIcon: NSMenuItem!
    var menuItemHelp: NSMenuItem!
    var menuItemQuit: NSMenuItem!
    let aboutWindowController: HAFAboutWindowController? = HAFAboutWindowController.init()
    let preferencesWindowController: HAFPreferencesWindowController? = HAFPreferencesWindowController.init()
    
    init() {
        var offsetX: CGFloat = 0
        if nil != NSScreen.main {
            offsetX = NSScreen.main!.frame.width - 150
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
        menuItemShowDesktop = NSMenuItem.init(title: NSLocalizedString("Display Desktop", comment: ""), action: #selector(showDesktopMenuItem_click), keyEquivalent: "")
        menuItemAutoHideMouseCursor = NSMenuItem.init(title: NSLocalizedString("Hide The Mouse Cursor Automatically", comment: ""), action: #selector(autoHideMouseCursorMenuItem_click), keyEquivalent: "")
       menuItemAutoHideDesktopIcons = NSMenuItem.init(title: NSLocalizedString("Hide Desktop Icons Automatically", comment: ""), action: #selector(autoHideDesktopIcons_click), keyEquivalent: "")
       menuItemRateOnMacAppStore = NSMenuItem.init(title: NSLocalizedString("Rate On Mac App Store", comment: ""), action: #selector(rateOnMacAppStore_click), keyEquivalent: "")
        menuItemDisplayKaka = NSMenuItem.init(title: NSLocalizedString("Display Kaka", comment: ""), action: #selector(displayKakaMenuItem_click), keyEquivalent: "")
        menuItemPreventSystemSleep = NSMenuItem.init(title: NSLocalizedString("Prevent System From Falling Asleep", comment: ""), action: #selector(PreventSystemSleepMenuItem_click), keyEquivalent: "")
        menuItemShowDesktopIcon = NSMenuItem.init(title: NSLocalizedString("Hide Desktop Icons", comment: ""), action: #selector(showDesktopIconMenuItem_click), keyEquivalent: "")
        menuItemHelp = NSMenuItem.init(title: NSLocalizedString("Help", comment: ""), action: #selector(help_click), keyEquivalent: "")
        menuItemQuit = NSMenuItem.init(title: NSLocalizedString("Quit", comment: ""), action: #selector(quit_click), keyEquivalent: "")
        
        super.init(window: wnd)
        
        menuItemAbout.target = self
        menuItemPreferences.target = self
        menuItemPreventSystemSleep.target = self
        menuItemShowDesktop.target = self
        menuItemShowDesktopIcon.target = self
        menuItemPreventSystemSleep.target = self
        menuItemAutoHideMouseCursor.target = self
        menuItemAutoHideDesktopIcons.target = self
        menuItemRateOnMacAppStore.target = self
        menuItemDisplayKaka.target = self
        menuItemHelp.target = self
        menuItemQuit.target = self
        
        actionMenu.insertItem(menuItemShowDesktop, at: 0)
        actionMenu.insertItem(menuItemShowDesktopIcon, at: 1)
        actionMenu.insertItem(menuItemPreventSystemSleep, at: 2)
        actionMenu.insertItem(menuItemAutoHideMouseCursor, at: 3)
        actionMenu.insertItem(menuItemAutoHideDesktopIcons, at: 4)
        actionMenu.insertItem(NSMenuItem.separator(), at: 5)
        actionMenu.insertItem(menuItemDisplayKaka, at: 6)
        actionMenu.insertItem(NSMenuItem.separator(), at: 7)
        actionMenu.insertItem(menuItemAbout, at: 8)
        actionMenu.insertItem(menuItemPreferences, at: 9)
        actionMenu.insertItem(menuItemRateOnMacAppStore, at: 10)
        actionMenu.insertItem(menuItemHelp, at: 11)
        actionMenu.insertItem(NSMenuItem.separator(), at: 12)
        actionMenu.insertItem(menuItemQuit, at: 13)
        _view.delegate = self
        
        wnd.setDraggingCallback(areaFunc: draggingArea, completedFunc: draggingCompleted)
        
        if HAFConfigureManager.sharedManager.isAutoHideMouseCursor() {
            menuItemAutoHideMouseCursor.state = .on
            SSCursorManager.shared().setAutoHideTimeout(3)
        }
        
        if HAFConfigureManager.sharedManager.isPreventSystemFromFallingAsleep() {
            menuItemPreventSystemSleep.state = .on
            SSDesktopManager.shared().preventSleep(true)
        }
        
        SSDesktopManager.shared().setMouseActionCallback({ (windowType, eventType, event,context)  in
            if HAFConfigureManager.sharedManager.isDoubleClickDesktopToShowIcons() && DM_DESKTOP_COVER_WINDOW == windowType && 2 == event?.clickCount{
                DispatchQueue.main.async {
                    SSDesktopManager.shared().uncoverDesktop()
                }
            }
        }, withContext: nil)
        
        if HAFConfigureManager.sharedManager.isAutoHideDesktopIcons(){
            menuItemAutoHideDesktopIcons.state = .on
            SSDesktopManager.shared().desktopCoverImageView().image = SSDesktopManager.shared().snapshotDesktopImage()
            SSDesktopManager.shared().setAutoCoverDesktopTimeout(10)
        }
        
        menuItemDisplayKaka.state = .on
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
            if menuItemShowDesktopIcon.state == .off {
                menuItemShowDesktopIcon.state = .on
            }else{
                menuItemShowDesktopIcon.state = .off
            }
            __showDesktopIcons()
        }
    }
    
    func rightButtonClick() -> Void{
        updateActionMenu()
        NSMenu.popUpContextMenu(actionMenu, with: NSApp.currentEvent!, for: _view)
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
        if menuItemShowDesktopIcon.state == .off {
            menuItemShowDesktopIcon.state = .on
        }else{
            menuItemShowDesktopIcon.state = .off
        }
        __showDesktopIcons()
    }
    
    @IBAction func PreventSystemSleepMenuItem_click(sender: AnyObject?){
        if menuItemPreventSystemSleep.state == .off {
            menuItemPreventSystemSleep.state = .on
            SSDesktopManager.shared().preventSleep(true)
        }else{
            menuItemPreventSystemSleep.state = .off
            SSDesktopManager.shared().preventSleep(false)
        }
    }
    
    @IBAction func autoHideMouseCursorMenuItem_click(sender: AnyObject?){
        if menuItemAutoHideMouseCursor.state == .off {
            menuItemAutoHideMouseCursor.state = .on
            SSCursorManager.shared().setAutoHideTimeout(3)
        }else{
            menuItemAutoHideMouseCursor.state = .off
            SSCursorManager.shared().setAutoHideTimeout(0)
        }
    }
    
    @IBAction func autoHideDesktopIcons_click(sender: AnyObject?){
        if menuItemAutoHideDesktopIcons.state == .off {
            menuItemAutoHideDesktopIcons.state = .on
            SSDesktopManager.shared().desktopCoverImageView().image = SSDesktopManager.shared().snapshotDesktopImage()
            SSDesktopManager.shared().setAutoCoverDesktopTimeout(10)
        }else{
            menuItemAutoHideDesktopIcons.state = .off
            SSDesktopManager.shared().setAutoCoverDesktopTimeout(0)
        }
        HAFConfigureManager.sharedManager.setAutoHideDesktopIcons(bFlag: menuItemAutoHideDesktopIcons.state == .on)
    }
    
    @IBAction func rateOnMacAppStore_click(sender: AnyObject?){
        NSWorkspace.shared.open(URL.init(string: "macappstore://itunes.apple.com/app/id1434172933")!)
    }
    
    @IBAction func displayKakaMenuItem_click(sender: AnyObject?){
        if menuItemDisplayKaka.state == .off {
            menuItemDisplayKaka.state = .on
            self.window?.makeKeyAndOrderFront(nil)
        }else{
            menuItemDisplayKaka.state = .off
            self.window?.orderOut(nil)
        }
    }
    
    @IBAction func help_click(sender: AnyObject?){
        NSWorkspace.shared.open(URL.init(string: "https://hsiangho.github.io/2018/06/13/SupportPage/")!)
    }
    
    @IBAction func quit_click(sender: AnyObject?){
        _kakaObj!.doAction(actionType: .eExit, clearFlag: true)
        _kakaObj!.skipCurrentAnimationSequenceChain()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NSApplication.shared.terminate(nil)
        }
    }
    
    //MARK: Public functions
    func updateActionMenu() -> Void{
        menuItemShowDesktopIcon.state = SSDesktopManager.shared().desktopCoverWindow().isVisible ? .on : .off
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
            SSDesktopManager.shared().desktopCoverImageView().image = SSDesktopManager.shared().snapshotDesktopImage()
            SSDesktopManager.shared().coverDesktop()
        }
    }
}
