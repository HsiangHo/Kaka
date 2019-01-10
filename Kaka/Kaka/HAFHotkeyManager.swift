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
}

class HAFHotkeyManager: NSObject {
    static let sharedManager = HAFHotkeyManager()
    
    var predefinedHotkeys: Array<(String, SCHotkey)> = Array.init()
    private var displayDesktopHotkey: SCHotkey?
    private var hideDesktopIconsHotkey: SCHotkey?
    private var turnOffDisplayHotkey: SCHotkey?
    private var turnOnDarkModeHotkey: SCHotkey?
    
    override init() {
        super.init()
        __initializePredefinedHotkeys()
    }
    
    func __initializePredefinedHotkeys() -> Void {
        displayDesktopHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.displayDesktop), identifier: HotkeyIdentifiers.displayDesktop, handler: { (_) in
            SSDesktopManager.shared().showDesktop(false)
        })
        predefinedHotkeys.append((NSLocalizedString("Display Desktop", comment: ""), displayDesktopHotkey!))
        
        hideDesktopIconsHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.hideDesktopIcons), identifier: HotkeyIdentifiers.hideDesktopIcons, handler: { (_) in
            if SSDesktopManager.shared().isAllDesktopCovered(){
                SSDesktopManager.shared().uncoverAllDesktop()
            }else{
                SSDesktopManager.shared().setupAllDesktopWithDesktopBackgroundImage()
                SSDesktopManager.shared().coverAllDesktop()
            }
        })
        predefinedHotkeys.append((NSLocalizedString("Hide Desktop Icons", comment: ""), hideDesktopIconsHotkey!))
        
        turnOffDisplayHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.turnOffDisplay), identifier: HotkeyIdentifiers.turnOffDisplay, handler: { (_) in
            SSEnergyManager.shared().displaySleep()
        })
        predefinedHotkeys.append((NSLocalizedString("Turn Off The Display", comment: ""), turnOffDisplayHotkey!))
        
        turnOnDarkModeHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.keyComboWithIdentifier(identifier: HotkeyIdentifiers.turnOnDarkMode), identifier: HotkeyIdentifiers.turnOnDarkMode, handler: { (_) in
            SSAppearanceManager.shared().toggle()
        })
        predefinedHotkeys.append((NSLocalizedString("Turn On Dark Mode", comment: ""), turnOnDarkModeHotkey!))
    }
}
