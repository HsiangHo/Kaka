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
    
    var predefinedHotkeysDict: Dictionary<String, SCHotkey> = Dictionary.init()
    private var displayDesktopHotkey: SCHotkey?
    private var hideDesktopIconsHotkey: SCHotkey?
    private var turnOffDisplayHotkey: SCHotkey?
    private var turnOnDarkModeHotkey: SCHotkey?
    
    override init() {
        super.init()
        __initializePredefinedHotkeys()
    }
    
    func __initializePredefinedHotkeys() -> Void {
        displayDesktopHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.displayDesktopKeyCombo(), identifier: "displayDesktop", handler: { (_) in
            SSDesktopManager.shared().showDesktop(false)
        });
        predefinedHotkeysDict.updateValue(displayDesktopHotkey!, forKey: NSLocalizedString("Display Desktop", comment: ""))
        
        hideDesktopIconsHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.hideDesktopIconsKeyCombo(), identifier: "hideDesktopIcons", handler: { (_) in
            if SSDesktopManager.shared().isAllDesktopCovered(){
                SSDesktopManager.shared().uncoverAllDesktop()
            }else{
                SSDesktopManager.shared().setupAllDesktopWithDesktopBackgroundImage()
                SSDesktopManager.shared().coverAllDesktop()
            }
        });
        predefinedHotkeysDict.updateValue(hideDesktopIconsHotkey!, forKey: NSLocalizedString("Hide Desktop Icons", comment: ""))
        
        turnOffDisplayHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.turnOffDisplayKeyCombo(), identifier: "turnOffDisplay", handler: { (_) in
            SSEnergyManager.shared().displaySleep()
        });
        predefinedHotkeysDict.updateValue(turnOffDisplayHotkey!, forKey: NSLocalizedString("Turn Off The Display", comment: ""))
        
        turnOnDarkModeHotkey = SCHotkey.init(keyCombo: HAFConfigureManager.sharedManager.turnOnDarkModeKeyCombo(), identifier: "turnOnDarkMode", handler: { (_) in
            SSAppearanceManager.shared().toggle()
        });
        predefinedHotkeysDict.updateValue(turnOnDarkModeHotkey!, forKey: NSLocalizedString("Turn On Dark Mode", comment: ""))
    }
}
