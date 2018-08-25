//
//  HAFConfigureManager.swift
//  Kaka
//
//  Created by Jovi on 8/25/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa
import ServiceManagement

class HAFConfigureManager: NSObject {
    static let sharedManager = HAFConfigureManager()
    let helperBundleIdentifier = "com.HyperartFlow.Kaka.launchAtLoginHelper"
    
    let kAutoHideMouseCursor = "kAutoHideMouseCursor"
    let kOneClickToHideDesktopIcons = "kOneClickToHideDesktopIcons"
    let kDoubleClickToShowDesktop = "kDoubleClickToShowDesktop"
    
    func setLaunchAtLogin(bFlag: Bool) -> Void {
        SMLoginItemSetEnabled(helperBundleIdentifier as CFString, bFlag)
    }
    
    func isLaunchAtLogin() -> Bool {
        guard let jobs = (SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as? [[String: AnyObject]]) else {
            return false
        }
        let job = jobs.first { $0["Label"] as! String == helperBundleIdentifier}
        return job?["OnDemand"] as? Bool ?? false
    }
    
    func setAutoHideMouseCursor(bFlag: Bool) -> Void {
        UserDefaults.standard.set(!bFlag, forKey: kAutoHideMouseCursor)
    }
    
    func isAutoHideMouseCursor() -> Bool {
        return !UserDefaults.standard.bool(forKey: kAutoHideMouseCursor)
    }
    
    func setOneClickToHideDesktopIcons(bFlag: Bool) -> Void{
        UserDefaults.standard.set(!bFlag, forKey: kOneClickToHideDesktopIcons)
    }
    
    func isOneClickToHideDesktopIcons() -> Bool{
        return !UserDefaults.standard.bool(forKey: kOneClickToHideDesktopIcons)
    }
    
    func setDoubleClickToShowDesktop(bFlag: Bool) -> Void{
        UserDefaults.standard.set(!bFlag, forKey: kDoubleClickToShowDesktop)
    }
    
    func isDoubleClickToShowDesktop() -> Bool{
        return !UserDefaults.standard.bool(forKey: kDoubleClickToShowDesktop)
    }
}
