//
//  HAFPreferencesWindowController.swift
//  Kaka
//
//  Created by Jovi on 8/24/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFPreferencesWindowController: NSWindowController {
    var _btnLaunchAtLogin: NSButton!
    var _btnAutoHideMouseCursor: NSButton!
    var _btnOneClickToHideDesktopIcon: NSButton!
    var _btnDoubleClickToShowDesktop: NSButton!

    init() {
        let frame = NSMakeRect(0, 0, 550, 180)
        let wnd = NSWindow.init(contentRect: frame, styleMask: [.titled, .closable, .fullSizeContentView], backing: .buffered, defer: false)
        wnd.backgroundColor = NSColor.white
        wnd.titlebarAppearsTransparent = true
        wnd.standardWindowButton(.zoomButton)?.isHidden = true
        wnd.standardWindowButton(.miniaturizeButton)?.isHidden = true
        wnd.title = NSLocalizedString("Preferences", comment: "")
        super.init(window: wnd)
        
        let visualEffectView: NSVisualEffectView = NSVisualEffectView.init(frame: frame)
        wnd.contentView = visualEffectView

        _btnLaunchAtLogin = NSButton.init(frame: NSMakeRect(20, NSHeight(frame) - 70, NSWidth(frame), 23))
        _btnLaunchAtLogin.title = NSLocalizedString("Launch at login", comment: "")
        _btnLaunchAtLogin.setButtonType(.switch)
        _btnLaunchAtLogin.target = self
        _btnLaunchAtLogin.action = #selector(launchAtLogin_click)
        _btnLaunchAtLogin.state = HAFConfigureManager.sharedManager.isLaunchAtLogin() ? .on : .off
        wnd.contentView?.addSubview(_btnLaunchAtLogin)
        
        _btnAutoHideMouseCursor = NSButton.init(frame: NSMakeRect(20, NSMinY(_btnLaunchAtLogin.frame) - 30, NSWidth(frame), 23))
        _btnAutoHideMouseCursor.title = NSLocalizedString("Hide the mouse cursor automatically", comment: "")
        _btnAutoHideMouseCursor.setButtonType(.switch)
        _btnAutoHideMouseCursor.target = self
        _btnAutoHideMouseCursor.action = #selector(autoHideMouseCursor_click)
        _btnAutoHideMouseCursor.state = HAFConfigureManager.sharedManager.isAutoHideMouseCursor() ? .on : .off
        wnd.contentView?.addSubview(_btnAutoHideMouseCursor)
        
        _btnOneClickToHideDesktopIcon = NSButton.init(frame: NSMakeRect(20, NSMinY(_btnAutoHideMouseCursor.frame) - 30, NSWidth(frame), 23))
        _btnOneClickToHideDesktopIcon.title = NSLocalizedString("One-click 'Kaka' to show/hide desktop icons", comment: "")
        _btnOneClickToHideDesktopIcon.setButtonType(.switch)
        _btnOneClickToHideDesktopIcon.target = self
        _btnOneClickToHideDesktopIcon.action = #selector(oneClickToHideDesktopIcons_click)
        _btnOneClickToHideDesktopIcon.state = HAFConfigureManager.sharedManager.isOneClickToHideDesktopIcons() ? .on : .off
        wnd.contentView?.addSubview(_btnOneClickToHideDesktopIcon)
        
        _btnDoubleClickToShowDesktop = NSButton.init(frame: NSMakeRect(20, NSMinY(_btnOneClickToHideDesktopIcon.frame) - 30, NSWidth(frame), 23))
        _btnDoubleClickToShowDesktop.title = NSLocalizedString("Double-click 'kaka' to show desktop", comment: "")
        _btnDoubleClickToShowDesktop.setButtonType(.switch)
        _btnDoubleClickToShowDesktop.target = self
        _btnDoubleClickToShowDesktop.action = #selector(doubleClickToShowDesktop)
        _btnDoubleClickToShowDesktop.state = HAFConfigureManager.sharedManager.isDoubleClickToShowDesktop() ? .on : .off
        wnd.contentView?.addSubview(_btnDoubleClickToShowDesktop)
        
        wnd.center()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func launchAtLogin_click(sender: AnyObject?){
        HAFConfigureManager.sharedManager.setLaunchAtLogin(bFlag: _btnLaunchAtLogin.state == .on)
    }
    
    @IBAction func autoHideMouseCursor_click(sender: AnyObject?){
        HAFConfigureManager.sharedManager.setAutoHideMouseCursor(bFlag: _btnAutoHideMouseCursor.state == .on)
    }
    
    @IBAction func oneClickToHideDesktopIcons_click(sender: AnyObject?){
        HAFConfigureManager.sharedManager.setOneClickToHideDesktopIcons(bFlag: _btnOneClickToHideDesktopIcon.state == .on)
    }
    
    @IBAction func doubleClickToShowDesktop(sender: AnyObject?){
        HAFConfigureManager.sharedManager.setDoubleClickToShowDesktop(bFlag: _btnDoubleClickToShowDesktop.state == .on)
    }
}
