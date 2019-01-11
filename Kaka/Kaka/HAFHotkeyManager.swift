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

struct HotkeyIdentifiers {
    static let displayDesktop = "displayDesktop"
    static let hideDesktopIcons = "hideDesktopIcons"
    static let turnOffDisplay = "turnOffDisplay"
    static let turnOnDarkMode = "turnOnDarkMode"
    static let sleepMac = "sleepMac"
    static let enterScreensaver = "enterScreensaver"
    static let preventSleep = "enterScreensaver"
    static let disableMouseCursor = "disableMouseCursor"
}

class HAFHotkeyManager: NSObject {
    static let sharedManager = HAFHotkeyManager()
    
    var preDefinedHotkeys: Array<(String, SCHotkey)> = Array.init()
    private var displayDesktopHotkey: SCHotkey?
    private var hideDesktopIconsHotkey: SCHotkey?
    private var turnOffDisplayHotkey: SCHotkey?
    private var turnOnDarkModeHotkey: SCHotkey?
    private var sleepMacHotkey: SCHotkey?
    private var enterScreensaverHotkey: SCHotkey?
    private var preventSleepHotkey: SCHotkey?
    private var disableMouseCursorHotkey: SCHotkey?
    
    override init() {
        super.init()
        __initializePredefinedHotkeys()
    }
    
    func __initializePredefinedHotkeys() -> Void {
        displayDesktopHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.displayDesktop), identifier: HotkeyIdentifiers.displayDesktop, handler: { (_) in
            SSDesktopManager.shared().showDesktop(false)
        })
        preDefinedHotkeys.append((NSLocalizedString("Display Desktop", comment: ""), displayDesktopHotkey!))
        
        hideDesktopIconsHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.hideDesktopIcons), identifier: HotkeyIdentifiers.hideDesktopIcons, handler: { (_) in
            if SSDesktopManager.shared().isAllDesktopCovered(){
                SSDesktopManager.shared().uncoverAllDesktop()
            }else{
                SSDesktopManager.shared().setupAllDesktopWithDesktopBackgroundImage()
                SSDesktopManager.shared().coverAllDesktop()
            }
        })
        preDefinedHotkeys.append((NSLocalizedString("Hide Desktop Icons", comment: ""), hideDesktopIconsHotkey!))
        
        turnOffDisplayHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.turnOffDisplay), identifier: HotkeyIdentifiers.turnOffDisplay, handler: { (_) in
            SSEnergyManager.shared().displaySleep()
        })
        preDefinedHotkeys.append((NSLocalizedString("Turn Off The Display", comment: ""), turnOffDisplayHotkey!))
        
        turnOnDarkModeHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.turnOnDarkMode), identifier: HotkeyIdentifiers.turnOnDarkMode, handler: { (_) in
            SSAppearanceManager.shared().toggle()
        })
        preDefinedHotkeys.append((NSLocalizedString("Turn On Dark Mode", comment: ""), turnOnDarkModeHotkey!))
        
        sleepMacHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.sleepMac), identifier: HotkeyIdentifiers.sleepMac, handler: { (_) in
            SSEnergyManager.shared().sleep()
        })
        preDefinedHotkeys.append((NSLocalizedString("Sleep Mac", comment: ""), sleepMacHotkey!))
        
        enterScreensaverHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.enterScreensaver), identifier: HotkeyIdentifiers.enterScreensaver, handler: { (_) in
            SSEnergyManager.shared().screenSaver()
        })
        preDefinedHotkeys.append((NSLocalizedString("Enter Screensaver", comment: ""), enterScreensaverHotkey!))
        
        preventSleepHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.preventSleep), identifier: HotkeyIdentifiers.preventSleep, handler: { (_) in
            SSEnergyManager.shared().preventSleep(!SSEnergyManager.shared().isPreventSleepRunning())
        })
        preDefinedHotkeys.append((NSLocalizedString("Prevent Sleep", comment: ""), preventSleepHotkey!))
        
        disableMouseCursorHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.disableMouseCursor), identifier: HotkeyIdentifiers.disableMouseCursor, handler: { (_) in
            if SSCursorManager.shared().isCursorEnable(){
                SSCursorManager.shared().disableCursor()
            }else{
                SSCursorManager.shared().enableCursor()
            }
        })
        preDefinedHotkeys.append((NSLocalizedString("Disable Mouse Cursor", comment: ""), disableMouseCursorHotkey!))
    }
}
