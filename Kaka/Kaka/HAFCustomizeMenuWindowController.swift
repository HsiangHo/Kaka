//
//  HAFCustomizeMenuWindowController.swift
//  Kaka
//
//  Created by Jovi on 1/13/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

import Cocoa

class HAFCustomizeMenuWindowController: NSWindowController {
    var btnDesktopMenuItem: NSButton?
    var btnDarkModeMenuItem: NSButton?
    var btnEnergyMenuItem: NSButton?
    var btnCursorMenuItem: NSButton?
    var btnKeyboardMenuItem: NSButton?
    var btnDisplayKakaMenuItem: NSButton?
    var btnShortcutsCenterMenuItem: NSButton?
    var btnAboutMenuItem: NSButton?
    var btnPreferencesMenuItem: NSButton?
    var btnFeedbackAndSpportMenuItem: NSButton?
    var lbTitle: NSTextField?
    
    init() {
        let frame = NSMakeRect(0, 0, 340, 415)
        let wnd = NSWindow.init(contentRect: frame, styleMask: [.titled, .closable, .fullSizeContentView], backing: .buffered, defer: false)
        wnd.backgroundColor = NSColor.white
        wnd.titlebarAppearsTransparent = true
        wnd.standardWindowButton(.zoomButton)?.isHidden = true
        wnd.standardWindowButton(.miniaturizeButton)?.isHidden = true
        super.init(window: wnd)
        
        let visualEffectView: NSVisualEffectView = NSVisualEffectView.init(frame: frame)
        wnd.contentView = visualEffectView
        
        wnd.center()
        
        btnFeedbackAndSpportMenuItem = NSButton.init(frame: NSMakeRect(30, 30, 300, 24))
        btnFeedbackAndSpportMenuItem?.setButtonType(.switch)
        btnFeedbackAndSpportMenuItem?.bezelStyle = .roundRect
        btnFeedbackAndSpportMenuItem?.title = NSLocalizedString("Feedback & Support", comment: "")
        btnFeedbackAndSpportMenuItem?.target = self
        btnFeedbackAndSpportMenuItem?.action = #selector(customizeMenu_click)
        wnd.contentView?.addSubview(btnFeedbackAndSpportMenuItem!)
        
        btnPreferencesMenuItem = NSButton.init(frame: NSMakeRect(NSMinX(btnFeedbackAndSpportMenuItem!.frame), NSMaxY(btnFeedbackAndSpportMenuItem!.frame) + 10, 300, 24))
        btnPreferencesMenuItem?.setButtonType(.switch)
        btnPreferencesMenuItem?.bezelStyle = .roundRect
        btnPreferencesMenuItem?.title = NSLocalizedString("Preferences", comment: "")
        btnPreferencesMenuItem?.target = self
        btnPreferencesMenuItem?.action = #selector(customizeMenu_click)
        wnd.contentView?.addSubview(btnPreferencesMenuItem!)
        
        btnAboutMenuItem = NSButton.init(frame: NSMakeRect(NSMinX(btnPreferencesMenuItem!.frame), NSMaxY(btnPreferencesMenuItem!.frame) + 10, 300, 24))
        btnAboutMenuItem?.setButtonType(.switch)
        btnAboutMenuItem?.bezelStyle = .roundRect
        btnAboutMenuItem?.title = NSLocalizedString("About", comment: "")
        btnAboutMenuItem?.target = self
        btnAboutMenuItem?.action = #selector(customizeMenu_click)
        wnd.contentView?.addSubview(btnAboutMenuItem!)
        
        btnShortcutsCenterMenuItem = NSButton.init(frame: NSMakeRect(NSMinX(btnAboutMenuItem!.frame), NSMaxY(btnAboutMenuItem!.frame) + 10, 300, 24))
        btnShortcutsCenterMenuItem?.setButtonType(.switch)
        btnShortcutsCenterMenuItem?.bezelStyle = .roundRect
        btnShortcutsCenterMenuItem?.title = NSLocalizedString("Shortcuts Center", comment: "")
        btnShortcutsCenterMenuItem?.target = self
        btnShortcutsCenterMenuItem?.action = #selector(customizeMenu_click)
        wnd.contentView?.addSubview(btnShortcutsCenterMenuItem!)
        
//        btnDisplayKakaMenuItem = NSButton.init(frame: NSMakeRect(NSMinX(btnShortcutsCenterMenuItem!.frame), NSMaxY(btnShortcutsCenterMenuItem!.frame) + 10, 300, 24))
//        btnDisplayKakaMenuItem?.setButtonType(.switch)
//        btnDisplayKakaMenuItem?.bezelStyle = .roundRect
//        btnDisplayKakaMenuItem?.title = NSLocalizedString("Display Kaka", comment: "")
//        btnDisplayKakaMenuItem?.target = self
//        btnDisplayKakaMenuItem?.action = #selector(customizeMenu_click)
//        wnd.contentView?.addSubview(btnDisplayKakaMenuItem!)
        
        btnKeyboardMenuItem = NSButton.init(frame: NSMakeRect(NSMinX(btnShortcutsCenterMenuItem!.frame), NSMaxY(btnShortcutsCenterMenuItem!.frame) + 10, 300, 24))
        btnKeyboardMenuItem?.setButtonType(.switch)
        btnKeyboardMenuItem?.bezelStyle = .roundRect
        btnKeyboardMenuItem?.title = NSLocalizedString("Keyboard", comment: "")
        btnKeyboardMenuItem?.target = self
        btnKeyboardMenuItem?.action = #selector(customizeMenu_click)
        wnd.contentView?.addSubview(btnKeyboardMenuItem!)
        
        btnCursorMenuItem = NSButton.init(frame: NSMakeRect(NSMinX(btnKeyboardMenuItem!.frame), NSMaxY(btnKeyboardMenuItem!.frame) + 10, 300, 24))
        btnCursorMenuItem?.setButtonType(.switch)
        btnCursorMenuItem?.bezelStyle = .roundRect
        btnCursorMenuItem?.title = NSLocalizedString("Cursor", comment: "")
        btnCursorMenuItem?.target = self
        btnCursorMenuItem?.action = #selector(customizeMenu_click)
        wnd.contentView?.addSubview(btnCursorMenuItem!)
        
        btnEnergyMenuItem = NSButton.init(frame: NSMakeRect(NSMinX(btnCursorMenuItem!.frame), NSMaxY(btnCursorMenuItem!.frame) + 10, 300, 24))
        btnEnergyMenuItem?.setButtonType(.switch)
        btnEnergyMenuItem?.bezelStyle = .roundRect
        btnEnergyMenuItem?.title = NSLocalizedString("Energy", comment: "")
        btnEnergyMenuItem?.target = self
        btnEnergyMenuItem?.action = #selector(customizeMenu_click)
        wnd.contentView?.addSubview(btnEnergyMenuItem!)
        
        btnDarkModeMenuItem = NSButton.init(frame: NSMakeRect(NSMinX(btnEnergyMenuItem!.frame), NSMaxY(btnEnergyMenuItem!.frame) + 10, 300, 24))
        btnDarkModeMenuItem?.setButtonType(.switch)
        btnDarkModeMenuItem?.bezelStyle = .roundRect
        btnDarkModeMenuItem?.title = NSLocalizedString("Dark Mode", comment: "")
        btnDarkModeMenuItem?.target = self
        btnDarkModeMenuItem?.action = #selector(customizeMenu_click)
        wnd.contentView?.addSubview(btnDarkModeMenuItem!)
        
        btnDesktopMenuItem = NSButton.init(frame: NSMakeRect(NSMinX(btnDarkModeMenuItem!.frame), NSMaxY(btnDarkModeMenuItem!.frame) + 10, 300, 24))
        btnDesktopMenuItem?.setButtonType(.switch)
        btnDesktopMenuItem?.bezelStyle = .roundRect
        btnDesktopMenuItem?.title = NSLocalizedString("Desktop", comment: "")
        btnDesktopMenuItem?.target = self
        btnDesktopMenuItem?.action = #selector(customizeMenu_click)
        wnd.contentView?.addSubview(btnDesktopMenuItem!)
        
        lbTitle = NSTextField.init(frame: NSMakeRect(NSMinX(btnDesktopMenuItem!.frame), NSMaxY(btnDesktopMenuItem!.frame) + 25, 300, 35))
        lbTitle!.alignment = .left
        lbTitle!.isEditable = false
        lbTitle!.isBezeled = false
        lbTitle!.isSelectable = false
        lbTitle!.backgroundColor = NSColor.clear
        lbTitle!.font = NSFont.init(name: "Helvetica Neue Light", size: 30)
        lbTitle!.stringValue = NSLocalizedString("Customize Menu", comment: "")
        wnd.contentView?.addSubview(lbTitle!)
        
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        updateUI()
    }
    
    @IBAction func customizeMenu_click(sender: AnyObject?){
        guard let btn: NSButton = sender as? NSButton else{
            return;
        }
        
        switch btn {
        case btnDesktopMenuItem:
            HAFConfigureManager.sharedManager.setMenuItemDesktopVisibility(bFlag: btnDesktopMenuItem?.state == .on)
        case btnDarkModeMenuItem:
            HAFConfigureManager.sharedManager.setMenuItemDarkModeVisibility(bFlag: btnDarkModeMenuItem?.state == .on)
        case btnEnergyMenuItem:
            HAFConfigureManager.sharedManager.setMenuItemEnergyVisibility(bFlag: btnEnergyMenuItem?.state == .on)
        case btnCursorMenuItem:
            HAFConfigureManager.sharedManager.setMenuItemCursorVisibility(bFlag: btnCursorMenuItem?.state == .on)
        case btnKeyboardMenuItem:
            HAFConfigureManager.sharedManager.setMenuItemKeyboardVisibility(bFlag: btnKeyboardMenuItem?.state == .on)
//        case btnDisplayKakaMenuItem:
//            HAFConfigureManager.sharedManager.setMenuItemDisplayKakaVisibility(bFlag: btnDisplayKakaMenuItem?.state == .on)
        case btnShortcutsCenterMenuItem:
            HAFConfigureManager.sharedManager.setMenuItemShortcutsCenterVisibility(bFlag: btnShortcutsCenterMenuItem?.state == .on)
        case btnAboutMenuItem:
            HAFConfigureManager.sharedManager.setMenuItemAboutVisibility(bFlag: btnAboutMenuItem?.state == .on)
        case btnPreferencesMenuItem:
            HAFConfigureManager.sharedManager.setMenuItemPreferencesVisibility(bFlag: btnPreferencesMenuItem?.state == .on)
        case btnFeedbackAndSpportMenuItem:
            HAFConfigureManager.sharedManager.setMenuItemFeedbackAndSpportVisibility(bFlag: btnFeedbackAndSpportMenuItem?.state == .on)
        default:
            NSLog("")
        }
    }
    
    func updateUI() -> Void {
        btnDesktopMenuItem?.state = HAFConfigureManager.sharedManager.menuItemDesktopVisibility() ? .on : .off
        btnDarkModeMenuItem?.state = HAFConfigureManager.sharedManager.menuItemDarkModeVisibility() ? .on : .off
        btnEnergyMenuItem?.state = HAFConfigureManager.sharedManager.menuItemEnergyVisibility() ? .on : .off
        btnCursorMenuItem?.state = HAFConfigureManager.sharedManager.menuItemCursorVisibility() ? .on : .off
        btnKeyboardMenuItem?.state = HAFConfigureManager.sharedManager.menuItemKeyboardVisibility() ? .on : .off
//        btnDisplayKakaMenuItem?.state = HAFConfigureManager.sharedManager.menuItemDisplayKakaVisibility() ? .on : .off
        btnShortcutsCenterMenuItem?.state = HAFConfigureManager.sharedManager.menuItemShortcutsCenterVisibility() ? .on : .off
        btnAboutMenuItem?.state = HAFConfigureManager.sharedManager.menuItemAboutVisibility() ? .on : .off
        btnPreferencesMenuItem?.state = HAFConfigureManager.sharedManager.menuItemPreferencesVisibility() ? .on : .off
        btnFeedbackAndSpportMenuItem?.state = HAFConfigureManager.sharedManager.menuItemFeedbackAndSpportVisibility() ? .on : .off
    }
}
