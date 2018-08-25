//
//  HAFAboutWindowController.swift
//  Kaka
//
//  Created by Jovi on 8/24/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFAboutWindowController: NSWindowController {
    var _btnAppIcon: NSButton!
    var _lbAppName: NSTextField!
    var _lbAppVersion: NSTextField!
    var _lbCopyright: NSTextField!

    init() {
        let frame = NSMakeRect(0, 0, 550, 386)
        let wnd = NSWindow.init(contentRect: frame, styleMask: [.titled, .closable, .fullSizeContentView], backing: .buffered, defer: false)
        wnd.backgroundColor = NSColor.white
        wnd.titlebarAppearsTransparent = true
        wnd.standardWindowButton(.zoomButton)?.isHidden = true
        wnd.standardWindowButton(.miniaturizeButton)?.isHidden = true
        super.init(window: wnd)
        
        _btnAppIcon = NSButton.init(frame: NSMakeRect((NSWidth(frame) - 150) * 0.5, NSHeight(frame) - 210, 150, 150))
        _btnAppIcon.image = NSImage.init(imageLiteralResourceName: "AppIcon")
        _btnAppIcon.title = ""
        _btnAppIcon.isBordered = false
        _btnAppIcon.bezelStyle = .roundRect
        _btnAppIcon.setButtonType(.momentaryChange)
        _btnAppIcon.target = self
        _btnAppIcon.action = #selector(appIcon_click)
        wnd.contentView?.addSubview(_btnAppIcon)
        
        _lbAppName = NSTextField.init(frame: NSMakeRect(0, NSMinY(_btnAppIcon.frame) - 60, NSWidth(frame), 42))
        _lbAppName.stringValue = "Kaka"
        _lbAppName.alignment = .center
        _lbAppName.isEditable = false
        _lbAppName.isSelectable = false
        _lbAppName.isBordered = false
        _lbAppName.font = NSFont.init(name: "Helvetica Neue Light", size: 42)
        wnd.contentView?.addSubview(_lbAppName)
        
        _lbAppVersion = NSTextField.init(frame: NSMakeRect(0, NSMinY(_lbAppName.frame) - 43, NSWidth(frame), 23))
        _lbAppVersion.stringValue = "Version: 1.0.0"
        _lbAppVersion.alignment = .center
        _lbAppVersion.isEditable = false
        _lbAppVersion.isSelectable = false
        _lbAppVersion.isBordered = false
        _lbAppVersion.font = NSFont.init(name: "Helvetica Neue Light", size: 15)
        wnd.contentView?.addSubview(_lbAppVersion)
        
        _lbCopyright = NSTextField.init(frame: NSMakeRect(0, NSMinY(_lbAppVersion.frame) - 20, NSWidth(frame), 22))
        _lbCopyright.stringValue = "Copyright (C) 2018 HyperartFlow. All Rights Reserved."
        _lbCopyright.alignment = .center
        _lbCopyright.isEditable = false
        _lbCopyright.isSelectable = false
        _lbCopyright.isBordered = false
        _lbCopyright.font = NSFont.init(name: "Helvetica Neue Light", size: 14)
        _lbCopyright.textColor = NSColor.gray
        wnd.contentView?.addSubview(_lbCopyright)
        
        wnd.center()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func appIcon_click(sender: AnyObject?){
        NSWorkspace.shared.open(URL.init(string: "https://github.com/HsiangHo/Kaka")!)
    }
}
