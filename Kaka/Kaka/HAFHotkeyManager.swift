//
//  HAFHotkeyManager.swift
//  Kaka
//
//  Created by Jovi on 10/23/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa
import ShortcutsKit
import ShadowstarKit

class HAFHotkeyManager: NSObject {
    static let sharedManager = HAFHotkeyManager()
    
    private var displayDesktopHotkey: SCHotkey?
    private var hideDesktopIconsHotkey: SCHotkey?
    private var turnOffDisplayHotkey: SCHotkey?
    private var turnOnDarkModeHotkey: SCHotkey?
    
    func registerAll() -> Void {
        setDisplayDesktopHotkey(keyCombo: HAFConfigureManager.sharedManager.displayDesktopKeyCombo())
        setHideDesktopIconsHotkey(keyCombo: HAFConfigureManager.sharedManager.hideDesktopIconsKeyCombo())
        setTurnOffDisplayHotkey(keyCombo: HAFConfigureManager.sharedManager.turnOffDisplayKeyCombo())
        setTurnOnDarkModeHotkey(keyCombo: HAFConfigureManager.sharedManager.turnOnDarkModeKeyCombo())
    }
    
    func unregisterAll() -> Void {
        if nil != displayDesktopHotkey{
            displayDesktopHotkey!.unregister()
        }
        if nil != hideDesktopIconsHotkey{
            hideDesktopIconsHotkey!.unregister()
        }
        if nil != turnOffDisplayHotkey{
            turnOffDisplayHotkey!.unregister()
        }
        if nil != turnOnDarkModeHotkey{
            turnOnDarkModeHotkey!.unregister()
        }
    }
    
    //Display desktop hotkey
    func setDisplayDesktopHotkey(keyCombo: SCKeyCombo?) -> Void {
        if nil != displayDesktopHotkey{
            displayDesktopHotkey!.unregister()
        }
        if nil != keyCombo {
            displayDesktopHotkey = SCHotkey.init(keyCombo: keyCombo!, identifier: "displayDesktop", handler: { (_) in
                SSDesktopManager.shared().showDesktop(false)
            });
            displayDesktopHotkey!.register()
        }
        HAFConfigureManager.sharedManager.setDisplayDesktopKeyCombo(keyCombo: keyCombo)
    }
    
    //Hide desktop icons hotkey
    func setHideDesktopIconsHotkey(keyCombo: SCKeyCombo?) -> Void {
        if nil != hideDesktopIconsHotkey{
            hideDesktopIconsHotkey!.unregister()
        }
        if nil != keyCombo {
            hideDesktopIconsHotkey = SCHotkey.init(keyCombo: keyCombo!, identifier: "hideDesktopIcons", handler: { (_) in
                if SSDesktopManager.shared().isAllDesktopCovered(){
                    SSDesktopManager.shared().uncoverAllDesktop()
                }else{
                    SSDesktopManager.shared().setupAllDesktopWithDesktopBackgroundImage()
                    SSDesktopManager.shared().coverAllDesktop()
                }
            });
            hideDesktopIconsHotkey!.register()
        }
        HAFConfigureManager.sharedManager.setHideDesktopIconsKeyCombo(keyCombo: keyCombo)
    }
    
    //Turn off display hotkey
    func setTurnOffDisplayHotkey(keyCombo: SCKeyCombo?) -> Void {
        if nil != turnOffDisplayHotkey{
            turnOffDisplayHotkey!.unregister()
        }
        if nil != keyCombo {
            turnOffDisplayHotkey = SCHotkey.init(keyCombo: keyCombo!, identifier: "turnOffDisplay", handler: { (_) in
                SSDesktopManager.shared().turnOffTheDisplay()
            });
            turnOffDisplayHotkey!.register()
        }
        HAFConfigureManager.sharedManager.setTurnOffDisplayKeyCombo(keyCombo: keyCombo)
    }
    
    //Turn on dark mode hotkey
    func setTurnOnDarkModeHotkey(keyCombo: SCKeyCombo?) -> Void {
        if nil != turnOnDarkModeHotkey{
            turnOnDarkModeHotkey!.unregister()
        }
        if nil != keyCombo {
            turnOnDarkModeHotkey = SCHotkey.init(keyCombo: keyCombo!, identifier: "turnOnDarkMode", handler: { (_) in
                SSAppearanceManager.shared().toggle()
            });
            turnOnDarkModeHotkey!.register()
        }
        HAFConfigureManager.sharedManager.setTurnOnDarkModeKeyCombo(keyCombo: keyCombo)
    }
}
