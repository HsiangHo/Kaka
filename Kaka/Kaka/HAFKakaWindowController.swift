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
    var menuItemDarkmode: NSMenuItem!
    var subMenuDarkmode: NSMenu!
    var menuItemDesktop: NSMenuItem!
    var subMenuDesktop: NSMenu!
    var menuItemCursor: NSMenuItem!
    var subMenuCursor: NSMenu!
    var menuItemPower: NSMenuItem!
    var subMenuPower: NSMenu!
    var menuItemDeactivateCriticalBatteryCharge: NSMenuItem!
    var menuItemDeactivateCriticalBatteryChargeThresholdSlider: NSMenuItem!
    var deactivateCriticalBatteryChargeThresholdSlider: NSSlider!
    var menuItemPreventSystemSleep: NSMenuItem!
    var menuItemPreventSystemSleepFor5Mins: NSMenuItem!
    var menuItemPreventSystemSleepFor10Mins: NSMenuItem!
    var menuItemPreventSystemSleepFor15Mins: NSMenuItem!
    var menuItemPreventSystemSleepFor30Mins: NSMenuItem!
    var menuItemPreventSystemSleepFor1Hour: NSMenuItem!
    var menuItemPreventSystemSleepFor2Hours: NSMenuItem!
    var menuItemPreventSystemSleepFor5Hours: NSMenuItem!
    var menuItemAutoHideMouseCursor: NSMenuItem!
    var menuItemAutoHideDesktopIcons: NSMenuItem!
//    var menuItemShowHiddenFilesAndFolders: NSMenuItem!
//    var menuItemEnableFinderExtension: NSMenuItem!
    var menuItemTurnOffTheDisplay: NSMenuItem!
    var menuItemSleep: NSMenuItem!
    var menuItemScreenSaver: NSMenuItem!
    var menuItemClamshellCausingSleep: NSMenuItem!
    var menuItemTurnOnDarkMode: NSMenuItem!
    var menuItemTurnOnDarkModeBaseOnDisplayBrightness: NSMenuItem!
    var menuItemToggleDarkModeThresholdSlider: NSMenuItem!
    var toggleDarkModeThresholdSlider: NSSlider!
    var menuItemCustomAppAppearance: NSMenuItem!
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
    let appAppearanceWindowController: HAFAppAppearanceWindowController? = HAFAppAppearanceWindowController.init()
    var _updateDesktopCoverTimer: DispatchSourceTimer?
    var _preventSleepTimer: DispatchSourceTimer?
    var _lastBatteryPercentage: Int = SSEnergyManager.shared().batteryPercentage()
    
    init() {
        let offsetX: CGFloat = NSScreen.screens[0].frame.width - 150
        let windowFrame = NSMakeRect(offsetX, 0, 215, 170)
        let frame = NSMakeRect(0, 0, NSWidth(windowFrame), NSHeight(windowFrame))
        let wnd = HAFAnimationWindow.init(contentRect: windowFrame, styleMask: .borderless, backing: .buffered, defer: false)
        wnd.contentView = HAFTransparentView.init(frame: frame)
        _view = HAFAnimationView.init(frame: frame)
        wnd.contentView?.addSubview(_view)
        actionMenu = NSMenu.init(title: "actionMenu")
        
        subMenuDarkmode = NSMenu.init(title: "darkModeMenu")
        menuItemDarkmode = NSMenuItem.init(title: NSLocalizedString("Dark Mode", comment: ""), action: nil, keyEquivalent: "")
        menuItemDarkmode.submenu = subMenuDarkmode
        
        subMenuDesktop = NSMenu.init(title: "desktopMenu")
        menuItemDesktop = NSMenuItem.init(title: NSLocalizedString("Desktop", comment: ""), action: nil, keyEquivalent: "")
        menuItemDesktop.submenu = subMenuDesktop
        
        subMenuCursor = NSMenu.init(title: "cursorMenu")
        menuItemCursor = NSMenuItem.init(title: NSLocalizedString("Cursor", comment: ""), action: nil, keyEquivalent: "")
        menuItemCursor.submenu = subMenuCursor
        
        subMenuPower = NSMenu.init(title: "Energy")
        menuItemPower = NSMenuItem.init(title: NSLocalizedString("Energy", comment: ""), action: nil, keyEquivalent: "")
        menuItemPower.submenu = subMenuPower
        
        menuItemAbout = NSMenuItem.init(title: NSLocalizedString("About", comment: ""), action: #selector(aboutMenuItem_click), keyEquivalent: "")
        menuItemPreferences = NSMenuItem.init(title: NSLocalizedString("Preferences", comment: ""), action: #selector(preferencesMenuItem_click), keyEquivalent: ",")
        menuItemShowDesktop = NSMenuItem.init(title: NSLocalizedString("Display Desktop", comment: ""), action: #selector(showDesktopMenuItem_click), keyEquivalent: "")
        var turnOnDarkModeBaseOnDisplayBrightness = NSLocalizedString("Toggle Dark Mode Base On Display Brightness", comment: "")
        turnOnDarkModeBaseOnDisplayBrightness = turnOnDarkModeBaseOnDisplayBrightness.appending(String(format:" (%d%%)", arguments:[Int(HAFConfigureManager.sharedManager.autoToggleDarkModeBaseOnDisplayBrightnessValue()*100)]))
//        menuItemShowHiddenFilesAndFolders = NSMenuItem.init(title: NSLocalizedString("Show Hidden Files & Folders",comment: ""), action: #selector(showHiddenFilesAndFolders_click), keyEquivalent: "")
        menuItemTurnOffTheDisplay = NSMenuItem.init(title: NSLocalizedString("Turn Off The Display",comment: ""), action: #selector(turnOffTheDisplay_click), keyEquivalent: "")
        menuItemSleep = NSMenuItem.init(title: NSLocalizedString("Sleep",comment: ""), action: #selector(sleep_click), keyEquivalent: "")
        menuItemScreenSaver = NSMenuItem.init(title: NSLocalizedString("Screensaver",comment: ""), action: #selector(screensaver_click), keyEquivalent: "")
        menuItemClamshellCausingSleep = NSMenuItem.init(title: NSLocalizedString("Prevent Sleep When Lid Is Closed",comment: ""), action: #selector(preventClamShellCausingSleep_click), keyEquivalent: "")
        menuItemTurnOnDarkModeBaseOnDisplayBrightness = NSMenuItem.init(title: turnOnDarkModeBaseOnDisplayBrightness, action: #selector(turnOnDarkModeBaseOnDisplayBrightnessMenuItem_click), keyEquivalent: "")
        menuItemToggleDarkModeThresholdSlider = NSMenuItem.init(title: "", action: nil, keyEquivalent: "")
        toggleDarkModeThresholdSlider = NSSlider.init(frame: NSMakeRect(0, 0, 200, 23))
        menuItemToggleDarkModeThresholdSlider.view = toggleDarkModeThresholdSlider
        menuItemTurnOnDarkMode = NSMenuItem.init(title: NSLocalizedString("Turn On Dark Mode", comment: ""), action: #selector(turnOnDarkModeMenuItem_click), keyEquivalent: "")
        menuItemCustomAppAppearance = NSMenuItem.init(title: NSLocalizedString("Custom Application Appearance", comment: ""), action: #selector(customAppAppearanceMenuItem_click), keyEquivalent: "")
        menuItemAutoHideMouseCursor = NSMenuItem.init(title: NSLocalizedString("Hide The Mouse Cursor Automatically", comment: ""), action: #selector(autoHideMouseCursorMenuItem_click), keyEquivalent: "")
       menuItemAutoHideDesktopIcons = NSMenuItem.init(title: NSLocalizedString("Hide Desktop Icons Automatically", comment: ""), action: #selector(autoHideDesktopIcons_click), keyEquivalent: "")
       menuItemRateOnMacAppStore = NSMenuItem.init(title: NSLocalizedString("Rate On Mac App Store", comment: ""), action: #selector(rateOnMacAppStore_click), keyEquivalent: "")
        menuItemDisplayKaka = NSMenuItem.init(title: NSLocalizedString("Display Kaka", comment: ""), action: #selector(displayKakaMenuItem_click), keyEquivalent: "")
        menuItemDeactivateCriticalBatteryCharge = NSMenuItem.init(title: NSLocalizedString("Deactivate Critical Battery Charge", comment: "") + " (10%)", action: #selector(deactivateCriticalBatteryCharge_click), keyEquivalent: "")
        menuItemDeactivateCriticalBatteryChargeThresholdSlider = NSMenuItem.init(title: "", action: nil, keyEquivalent: "")
        deactivateCriticalBatteryChargeThresholdSlider = NSSlider.init(frame: NSMakeRect(0, 0, 160, 23))
        menuItemDeactivateCriticalBatteryChargeThresholdSlider.view = deactivateCriticalBatteryChargeThresholdSlider
        menuItemPreventSystemSleep = NSMenuItem.init(title: NSLocalizedString("Prevent System From Falling Asleep", comment: ""), action: #selector(preventSystemSleepMenuItem_click), keyEquivalent: "")
        menuItemPreventSystemSleepFor5Mins = NSMenuItem.init(title: NSLocalizedString("For 5 Mins", comment: ""), action: #selector(preventSystemSleepFor5MinsMenuItem_click), keyEquivalent: "")
        menuItemPreventSystemSleepFor10Mins = NSMenuItem.init(title: NSLocalizedString("For 10 Mins", comment: ""), action: #selector(preventSystemSleepFor10MinsMenuItem_click), keyEquivalent: "")
        menuItemPreventSystemSleepFor15Mins = NSMenuItem.init(title: NSLocalizedString("For 15 Mins", comment: ""), action: #selector(preventSystemSleepFor15MinsMenuItem_click), keyEquivalent: "")
        menuItemPreventSystemSleepFor30Mins = NSMenuItem.init(title: NSLocalizedString("For 30 Mins", comment: ""), action: #selector(preventSystemSleepFor30MinsMenuItem_click), keyEquivalent: "")
        menuItemPreventSystemSleepFor1Hour = NSMenuItem.init(title: NSLocalizedString("For 1 Hour", comment: ""), action: #selector(preventSystemSleepFor1HourMenuItem_click), keyEquivalent: "")
        menuItemPreventSystemSleepFor2Hours = NSMenuItem.init(title: NSLocalizedString("For 2 Hours", comment: ""), action: #selector(preventSystemSleepFor2HoursMenuItem_click), keyEquivalent: "")
        menuItemPreventSystemSleepFor5Hours = NSMenuItem.init(title: NSLocalizedString("For 5 Hours", comment: ""), action: #selector(preventSystemSleepFor5HoursMenuItem_click), keyEquivalent: "")
        menuItemShowDesktopIcon = NSMenuItem.init(title: NSLocalizedString("Hide Desktop Icons", comment: ""), action: #selector(showDesktopIconMenuItem_click), keyEquivalent: "")
//        menuItemEnableFinderExtension = NSMenuItem.init(title: NSLocalizedString("Enable Finder Extension", comment: ""), action: #selector(enableFinderExtension_click), keyEquivalent: "")
        menuItemHelp = NSMenuItem.init(title: NSLocalizedString("Help", comment: ""), action: #selector(help_click), keyEquivalent: "")
        menuItemQuit = NSMenuItem.init(title: NSLocalizedString("Quit", comment: ""), action: #selector(quit_click), keyEquivalent: "q")
        
        super.init(window: wnd)
        
        toggleDarkModeThresholdSlider.floatValue = HAFConfigureManager.sharedManager.autoToggleDarkModeBaseOnDisplayBrightnessValue()
        toggleDarkModeThresholdSlider.target = self
        toggleDarkModeThresholdSlider.action = #selector(onBrightnessValueSliderChanged)
        toggleDarkModeThresholdSlider.autoresizingMask = [.minXMargin,.maxXMargin]
        
        deactivateCriticalBatteryChargeThresholdSlider.floatValue = HAFConfigureManager.sharedManager.deactivateCriticalBatteryChargeThreshold()
        deactivateCriticalBatteryChargeThresholdSlider.target = self
        deactivateCriticalBatteryChargeThresholdSlider.action = #selector(onDeactivateCriticalBatteryChargeSliderChanged)
        deactivateCriticalBatteryChargeThresholdSlider.autoresizingMask = [.minXMargin,.maxXMargin]
        
        menuItemAbout.target = self
        menuItemPreferences.target = self
        menuItemDeactivateCriticalBatteryCharge.target = self
        menuItemDeactivateCriticalBatteryChargeThresholdSlider.target = self
        menuItemPreventSystemSleep.target = self
        menuItemPreventSystemSleepFor5Mins.target = self
        menuItemPreventSystemSleepFor10Mins.target = self
        menuItemPreventSystemSleepFor15Mins.target = self
        menuItemPreventSystemSleepFor30Mins.target = self
        menuItemPreventSystemSleepFor1Hour.target = self
        menuItemPreventSystemSleepFor2Hours.target = self
        menuItemPreventSystemSleepFor5Hours.target = self
        menuItemShowDesktop.target = self
        menuItemShowDesktopIcon.target = self
//        menuItemShowHiddenFilesAndFolders.target = self
        menuItemTurnOffTheDisplay.target = self
        menuItemSleep.target = self
        menuItemScreenSaver.target = self
        menuItemClamshellCausingSleep.target = self
        menuItemTurnOnDarkModeBaseOnDisplayBrightness.target = self
        menuItemCustomAppAppearance.target = self
        menuItemToggleDarkModeThresholdSlider.target = self
        menuItemTurnOnDarkMode.target = self
        menuItemAutoHideMouseCursor.target = self
        menuItemAutoHideDesktopIcons.target = self
        menuItemRateOnMacAppStore.target = self
        menuItemDisplayKaka.target = self
//        menuItemEnableFinderExtension.target = self
        menuItemHelp.target = self
        menuItemQuit.target = self
        
        subMenuDesktop.addItem(menuItemShowDesktop)
        subMenuDesktop.addItem(menuItemShowDesktopIcon)
        subMenuDesktop.addItem(menuItemAutoHideDesktopIcons)
        
        subMenuDarkmode.addItem(menuItemTurnOnDarkMode)
        subMenuDarkmode.addItem(menuItemCustomAppAppearance)
        subMenuDarkmode.addItem(NSMenuItem.separator())
        subMenuDarkmode.addItem(menuItemTurnOnDarkModeBaseOnDisplayBrightness)
        subMenuDarkmode.addItem(menuItemToggleDarkModeThresholdSlider)
        
        subMenuPower.addItem(menuItemTurnOffTheDisplay)
        subMenuPower.addItem(menuItemSleep)
        subMenuPower.addItem(menuItemScreenSaver)
        subMenuPower.addItem(menuItemClamshellCausingSleep)
        subMenuPower.addItem(NSMenuItem.separator())
        subMenuPower.addItem(menuItemDeactivateCriticalBatteryCharge)
        subMenuPower.addItem(menuItemDeactivateCriticalBatteryChargeThresholdSlider)
        subMenuPower.addItem(NSMenuItem.separator())
        subMenuPower.addItem(menuItemPreventSystemSleep)
        subMenuPower.addItem(menuItemPreventSystemSleepFor5Mins)
        subMenuPower.addItem(menuItemPreventSystemSleepFor10Mins)
        subMenuPower.addItem(menuItemPreventSystemSleepFor15Mins)
        subMenuPower.addItem(menuItemPreventSystemSleepFor30Mins)
        subMenuPower.addItem(menuItemPreventSystemSleepFor1Hour)
        subMenuPower.addItem(menuItemPreventSystemSleepFor2Hours)
        subMenuPower.addItem(menuItemPreventSystemSleepFor5Hours)
        
        subMenuCursor.addItem(menuItemAutoHideMouseCursor)
        
        actionMenu.addItem(menuItemDesktop)
        actionMenu.addItem(menuItemDarkmode)
        actionMenu.addItem(menuItemPower)
        actionMenu.addItem(menuItemCursor)
        actionMenu.addItem(NSMenuItem.separator())
        actionMenu.addItem(menuItemDisplayKaka)
        actionMenu.addItem(NSMenuItem.separator())
        actionMenu.addItem(menuItemAbout)
        actionMenu.addItem(menuItemPreferences)
        actionMenu.addItem(menuItemRateOnMacAppStore)
        actionMenu.addItem(menuItemHelp)
        actionMenu.addItem(NSMenuItem.separator())
        actionMenu.addItem(menuItemQuit)
        _view.delegate = self
        
        wnd.setDraggingCallback(areaFunc: draggingArea, completedFunc: draggingCompleted)
        
        if HAFConfigureManager.sharedManager.isAutoHideMouseCursor() {
            menuItemAutoHideMouseCursor.state = .on
            let nTimeOut = HAFConfigureManager.sharedManager.autoHideCursorTimeOut()
            SSCursorManager.shared().setAutoHideTimeout(UInt(nTimeOut))
        }
        
        self.menuItemTurnOnDarkModeBaseOnDisplayBrightness.state = HAFConfigureManager.sharedManager.isAutoToggleDarkModeBaseOnDisplayBrightness() ? .on : .off
        self.menuItemDeactivateCriticalBatteryCharge.state = HAFConfigureManager.sharedManager.isDeactivateCriticalBatteryCharge() ? .on : .off
        
        let desktopObjs = SSDesktopManager.shared().desktopObjectsDictionary()
        for (_,value) in desktopObjs!{
            value.setMouseActionCallback({ (windowType, event, context)  in
                if HAFConfigureManager.sharedManager.isDoubleClickDesktopToShowIcons() && DO_DESKTOP_COVER_WINDOW == windowType && 2 == event?.clickCount{
                    DispatchQueue.main.async {
                        value.uncoverDesktop()
                    }
                }
            }, withContext: nil)
        }
        
        if HAFConfigureManager.sharedManager.isAutoHideDesktopIcons(){
            self.menuItemAutoHideDesktopIcons.state = .on
            SSDesktopManager.shared().setupAllDesktopWithDesktopBackgroundImage()
            let nTimeOut = HAFConfigureManager.sharedManager.autoHideDesktopIconTimeOut()
            SSDesktopManager.shared().setAutoCoverAllDesktopTimeout(UInt(nTimeOut))
            SSDesktopManager.shared().uncoverAllDesktop();
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                SSDesktopManager.shared().coverAllDesktop();
            })
        }
        
        SSDesktopManager.shared().setDesktopObjectsChangedBlock { (desktopObjsDict) in
            if HAFConfigureManager.sharedManager.isAutoHideDesktopIcons(){
                self.menuItemAutoHideDesktopIcons.state = .on
                SSDesktopManager.shared().setupAllDesktopWithDesktopBackgroundImage()
                let nTimeOut = HAFConfigureManager.sharedManager.autoHideDesktopIconTimeOut()
                SSDesktopManager.shared().setAutoCoverAllDesktopTimeout(UInt(nTimeOut))
                SSDesktopManager.shared().uncoverAllDesktop();
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    SSDesktopManager.shared().coverAllDesktop();
                })
                
                for (_,value) in desktopObjsDict!{
                    value.setMouseActionCallback({ (windowType, event, context)  in
                        if HAFConfigureManager.sharedManager.isDoubleClickDesktopToShowIcons() && DO_DESKTOP_COVER_WINDOW == windowType && 2 == event?.clickCount{
                            DispatchQueue.main.async {
                                value.uncoverDesktop()
                            }
                        }
                    }, withContext: nil)
                }
            }
        }
        
        if SSUtility.isFilePathAccessible(URL.init(fileURLWithPath: "/")) && HAFConfigureManager.sharedManager.isAutoToggleDarkModeBaseOnDisplayBrightness() {
            if SSBrightnessManager.shared().brightnessValue(eSSBrightness_Display) > HAFConfigureManager.sharedManager.autoToggleDarkModeBaseOnDisplayBrightnessValue() {
                SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
                    SSAppearanceManager.shared().disableDarkMode()
                }
            }else{
                SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
                    SSAppearanceManager.shared().enableDarkMode()
                }
            }
        }
        
//        if SSUtility.isFilePathAccessible(URL.init(fileURLWithPath: "/")){
//            SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
//                self.menuItemShowHiddenFilesAndFolders.state = SSAppearanceManager.shared().isShowAllFiles() ? .on : .off
//            }
//        }
        
        SSBrightnessManager.shared().setBrightnessValueChangedBlock { (value, type) in
            if !HAFConfigureManager.sharedManager.isAutoToggleDarkModeBaseOnDisplayBrightness(){
                return;
            }
            if eSSBrightness_Display == type{
                if value > HAFConfigureManager.sharedManager.autoToggleDarkModeBaseOnDisplayBrightnessValue() {
                    SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
                        SSAppearanceManager.shared().disableDarkMode()
                    }
                }else{
                    SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
                        SSAppearanceManager.shared().enableDarkMode()
                    }
                }
            }
        }
        
//        if HAFConfigureManager.sharedManager.isEnableFinderExtension(){
//            menuItemEnableFinderExtension.state = .on
//            __loadFinderPlugin()
//        }
        
        menuItemClamshellCausingSleep.state = !SSEnergyManager.shared().isClamshellCausingSleep() ? .on : .off
        
        if HAFConfigureManager.sharedManager.isEnableKaka(){
            menuItemDisplayKaka.state = .on
            self.window?.makeKeyAndOrderFront(nil)
            _view.isVisible = true
        }else{
            menuItemDisplayKaka.state = .off
            wnd.orderOut(nil)
            _view.isVisible = false
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(__monitorBatteryPercentage), name: NSNotification.Name.SSEnergyBatteryPercentageDidChanged, object: nil)
        
        __startToUpdateDesktopCover()
        
        HAFHotkeyManager.sharedManager.registerAll()
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
    
//    @IBAction func showHiddenFilesAndFolders_click(sender: AnyObject?){
//        SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
//            SSAppearanceManager.shared().setShowAllFiles(!SSAppearanceManager.shared().isShowAllFiles())
//        }
//    }
    @IBAction func turnOffTheDisplay_click(sender: AnyObject?){
        SSEnergyManager.shared().displaySleep()
    }
    
    @IBAction func sleep_click(sender: AnyObject?){
        SSEnergyManager.shared().sleep()
    }
    
    @IBAction func screensaver_click(sender: AnyObject?){
        SSEnergyManager.shared().screenSaver()
    }
    
    @IBAction func preventClamShellCausingSleep_click(sender: AnyObject?){
        let isClamshellCausingSleep = SSEnergyManager.shared().isClamshellCausingSleep()
        SSEnergyManager.shared().setClamshellCausingSleep(!isClamshellCausingSleep)
        menuItemClamshellCausingSleep.state = isClamshellCausingSleep ? .on : .off
    }
    
    @IBAction func showDesktopIconMenuItem_click(sender: AnyObject?){
        if menuItemShowDesktopIcon.state == .off {
            menuItemShowDesktopIcon.state = .on
        }else{
            menuItemShowDesktopIcon.state = .off
        }
        __showDesktopIcons()
    }
    
    @IBAction func deactivateCriticalBatteryCharge_click(sender: AnyObject?){
        if menuItemDeactivateCriticalBatteryCharge.state == .off {
            menuItemDeactivateCriticalBatteryCharge.state = .on
            HAFConfigureManager.sharedManager.setDeactivateCriticalBatteryCharge(bFlag: true)
        }else{
            menuItemDeactivateCriticalBatteryCharge.state = .off
            HAFConfigureManager.sharedManager.setDeactivateCriticalBatteryCharge(bFlag: false)
        }
    }
    
    @IBAction func preventSystemSleepMenuItem_click(sender: AnyObject?){
        __cancelPreventSleepTimeout()
        if menuItemPreventSystemSleep.state == .off {
            menuItemPreventSystemSleep.state = .on
            SSEnergyManager.shared().preventSleep(true)
        }else{
            menuItemPreventSystemSleep.state = .off
            SSEnergyManager.shared().preventSleep(false)
        }
    }
    
    @IBAction func preventSystemSleepFor5MinsMenuItem_click(sender: AnyObject?){
        menuItemPreventSystemSleep.state = .on
        SSEnergyManager.shared().preventSleep(true)
        __setPreventSleepTimeout(nTimeout: 300)
    }
    
    @IBAction func preventSystemSleepFor10MinsMenuItem_click(sender: AnyObject?){
        menuItemPreventSystemSleep.state = .on
        SSEnergyManager.shared().preventSleep(true)
        __setPreventSleepTimeout(nTimeout: 600)
    }
    
    @IBAction func preventSystemSleepFor15MinsMenuItem_click(sender: AnyObject?){
        menuItemPreventSystemSleep.state = .on
        SSEnergyManager.shared().preventSleep(true)
        __setPreventSleepTimeout(nTimeout: 900)
    }
    
    @IBAction func preventSystemSleepFor30MinsMenuItem_click(sender: AnyObject?){
        menuItemPreventSystemSleep.state = .on
        SSEnergyManager.shared().preventSleep(true)
        __setPreventSleepTimeout(nTimeout: 1800)
    }
    
    @IBAction func preventSystemSleepFor1HourMenuItem_click(sender: AnyObject?){
        menuItemPreventSystemSleep.state = .on
        SSEnergyManager.shared().preventSleep(true)
        __setPreventSleepTimeout(nTimeout: 3600)
    }
    
    @IBAction func preventSystemSleepFor2HoursMenuItem_click(sender: AnyObject?){
        menuItemPreventSystemSleep.state = .on
        SSEnergyManager.shared().preventSleep(true)
        __setPreventSleepTimeout(nTimeout: 7200)
    }
    
    @IBAction func preventSystemSleepFor5HoursMenuItem_click(sender: AnyObject?){
        menuItemPreventSystemSleep.state = .on
        SSEnergyManager.shared().preventSleep(true)
        __setPreventSleepTimeout(nTimeout: 18000)
    }
    
    @IBAction func autoHideMouseCursorMenuItem_click(sender: AnyObject?){
        if menuItemAutoHideMouseCursor.state == .off {
            menuItemAutoHideMouseCursor.state = .on
            let nTimeOut = HAFConfigureManager.sharedManager.autoHideCursorTimeOut()
            SSCursorManager.shared().setAutoHideTimeout(UInt(nTimeOut))
        }else{
            menuItemAutoHideMouseCursor.state = .off
            SSCursorManager.shared().setAutoHideTimeout(0)
        }
    }
    
    @IBAction func turnOnDarkModeBaseOnDisplayBrightnessMenuItem_click(sender: AnyObject?){
        if menuItemTurnOnDarkModeBaseOnDisplayBrightness.state == .off {
            menuItemTurnOnDarkModeBaseOnDisplayBrightness.state = .on
            HAFConfigureManager.sharedManager.setAutoToggleDarkModeBaseOnDisplayBrightness(bFlag: true)
        }else{
            menuItemTurnOnDarkModeBaseOnDisplayBrightness.state = .off
            HAFConfigureManager.sharedManager.setAutoToggleDarkModeBaseOnDisplayBrightness(bFlag: false)
        }
    }
    
    @IBAction func turnOnDarkModeMenuItem_click(sender: AnyObject?){
        SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
            if self.menuItemTurnOnDarkMode.state == .off {
                self.menuItemTurnOnDarkMode.state = .on
            }else{
                self.menuItemTurnOnDarkMode.state = .off
            }
            SSAppearanceManager.shared().toggle()
        }
    }
    
    @IBAction func customAppAppearanceMenuItem_click(sender: AnyObject?){
        appAppearanceWindowController?.window?.center()
        NSApp.activate(ignoringOtherApps: true)
        appAppearanceWindowController?.showWindow(nil)
    }
    
    @IBAction func autoHideDesktopIcons_click(sender: AnyObject?){
        if menuItemAutoHideDesktopIcons.state == .off {
            menuItemAutoHideDesktopIcons.state = .on
            SSDesktopManager.shared().setupAllDesktopWithDesktopBackgroundImage()
            let nTimeOut = HAFConfigureManager.sharedManager.autoHideDesktopIconTimeOut()
            SSDesktopManager.shared().setAutoCoverAllDesktopTimeout(UInt(nTimeOut))
        }else{
            menuItemAutoHideDesktopIcons.state = .off
            SSDesktopManager.shared().setAutoCoverAllDesktopTimeout(0)
        }
        HAFConfigureManager.sharedManager.setAutoHideDesktopIcons(bFlag: menuItemAutoHideDesktopIcons.state == .on)
    }
    
//    @IBAction func enableFinderExtension_click(sender: AnyObject?){
//        if menuItemEnableFinderExtension.state == .off {
//            menuItemEnableFinderExtension.state = .on
//            __loadFinderPlugin()
//        }else{
//            menuItemEnableFinderExtension.state = .off
//            __unloadFinderPlugin()
//        }
//        HAFConfigureManager.sharedManager.setEnableFinderExtension(bFlag: menuItemEnableFinderExtension.state == .on)
//    }
    
    @IBAction func rateOnMacAppStore_click(sender: AnyObject?){
        NSWorkspace.shared.open(URL.init(string: "macappstore://itunes.apple.com/app/id1434172933?action=write-review")!)
    }
    
    @IBAction func displayKakaMenuItem_click(sender: AnyObject?){
        if menuItemDisplayKaka.state == .off {
            menuItemDisplayKaka.state = .on
            self.window?.makeKeyAndOrderFront(nil)
            _view.isVisible = true
        }else{
            menuItemDisplayKaka.state = .off
            self.window?.orderOut(nil)
            _view.isVisible = false
        }
        HAFConfigureManager.sharedManager.setEnableKaka(bFlag: menuItemDisplayKaka.state == .on)
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
    
    @IBAction func onBrightnessValueSliderChanged(_ sender: NSSlider) {
        HAFConfigureManager.sharedManager.setAutoToggleDarkModeBaseOnDisplayBrightnessValue(value: toggleDarkModeThresholdSlider.floatValue)
        updateActionMenu()
    }
    
    @IBAction func onDeactivateCriticalBatteryChargeSliderChanged(_ sender: NSSlider) {
        HAFConfigureManager.sharedManager.setDeactivateCriticalBatteryChargeThreshold(nValue: deactivateCriticalBatteryChargeThresholdSlider.floatValue)
        updateActionMenu()
    }
    
    //MARK: Public functions
    func updateActionMenu() -> Void{
        menuItemShowDesktopIcon.state = SSDesktopManager.shared().isAllDesktopCovered() ? .on : .off
        menuItemTurnOnDarkMode.state = SSAppearanceManager.shared().isDarkMode() ? .on : .off
        var turnOnDarkModeBaseOnDisplayBrightness = NSLocalizedString("Toggle Dark Mode Base On Display Brightness", comment: "")
        turnOnDarkModeBaseOnDisplayBrightness = turnOnDarkModeBaseOnDisplayBrightness.appending(String(format:" (%d%%)", arguments:[Int(HAFConfigureManager.sharedManager.autoToggleDarkModeBaseOnDisplayBrightnessValue()*100)]))
        menuItemTurnOnDarkModeBaseOnDisplayBrightness.title = turnOnDarkModeBaseOnDisplayBrightness
        menuItemClamshellCausingSleep.state = !SSEnergyManager.shared().isClamshellCausingSleep() ? .on : .off
        toggleDarkModeThresholdSlider.floatValue = HAFConfigureManager.sharedManager.autoToggleDarkModeBaseOnDisplayBrightnessValue()
        var deactivateCriticalBatteryCharge = NSLocalizedString("Deactivate Critical Battery Charge", comment: "")
        deactivateCriticalBatteryCharge = deactivateCriticalBatteryCharge.appending(String(format:" (%d%%)", arguments:[Int(HAFConfigureManager.sharedManager.deactivateCriticalBatteryChargeThreshold()*100)]))
        menuItemDeactivateCriticalBatteryCharge.title = deactivateCriticalBatteryCharge
        deactivateCriticalBatteryChargeThresholdSlider.floatValue = HAFConfigureManager.sharedManager.deactivateCriticalBatteryChargeThreshold()
//        if SSUtility.isFilePathAccessible(URL.init(fileURLWithPath: "/")){
//            SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
//                self.menuItemShowHiddenFilesAndFolders.state = SSAppearanceManager.shared().isShowAllFiles() ? .on : .off
//            }
//        }
    }
    
    //MARK: Private functions
    func __showDesktop() -> Void {
        SSDesktopManager.shared().showDesktop(false)
    }
    
    func __showDesktopIcons() -> Void {
        //Desktop cover
        if SSDesktopManager.shared().isAllDesktopCovered(){
            SSDesktopManager.shared().uncoverAllDesktop()
        }else{
            SSDesktopManager.shared().setupAllDesktopWithDesktopBackgroundImage()
            SSDesktopManager.shared().coverAllDesktop()
        }
    }
    
    func __loadFinderPlugin() -> Void {
        SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
            let pluginPath: String = Bundle.main.bundlePath + "/Contents/PlugIns/FinderPlugin.appex"
            let cmd: String = String.init(format: "do shell script \"/usr/bin/pluginkit -a '%@'\"", pluginPath)
            SSUtility.execAppleScript(cmd, withCompletionHandler: { (_, _) in
                
            });
        }
    }
    
    func __unloadFinderPlugin() -> Void {
        let pluginPath: String = Bundle.main.bundlePath + "/Contents/PlugIns/FinderPlugin.appex"
        let cmd: String = String.init(format: "do shell script \"/usr/bin/pluginkit -r '%@'\"", pluginPath)
        SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
            SSUtility.execAppleScript(cmd, withCompletionHandler: { (_, _) in
                
            });
        }
    }
    
    func __startToUpdateDesktopCover(){
        _updateDesktopCoverTimer = DispatchSource.makeTimerSource(queue: .main)
        _updateDesktopCoverTimer?.schedule(wallDeadline: .now(), repeating: .seconds(60), leeway: .milliseconds(1))
        _updateDesktopCoverTimer?.setEventHandler {
            if SSDesktopManager.shared().isAllDesktopCovered(){
                SSDesktopManager.shared().setupAllDesktopWithDesktopBackgroundImage()
            }
        }
        _updateDesktopCoverTimer?.resume()
    }
    
    func __stopToUpdateDesktopCover(){
        _updateDesktopCoverTimer?.cancel()
        _updateDesktopCoverTimer = nil
    }
    
    @objc func __monitorBatteryPercentage(){
        let currentValue = SSEnergyManager.shared().batteryPercentage()
        let threshold = Int(HAFConfigureManager.sharedManager.deactivateCriticalBatteryChargeThreshold()*100)
        if _lastBatteryPercentage > threshold && currentValue <= threshold && HAFConfigureManager.sharedManager.isDeactivateCriticalBatteryCharge(){
            self.menuItemPreventSystemSleep.state = .off
            SSEnergyManager.shared().preventSleep(false)
        }
        _lastBatteryPercentage = currentValue
    }
    
    func __setPreventSleepTimeout(nTimeout: Int) -> Void {
        if nil != _preventSleepTimer {
            _preventSleepTimer?.cancel()
            _preventSleepTimer = nil
        }
        _preventSleepTimer = DispatchSource.makeTimerSource(queue: .main)
        _preventSleepTimer?.schedule(wallDeadline: .now() + .seconds(nTimeout), repeating: .never, leeway: .milliseconds(1))
        _preventSleepTimer?.setEventHandler {
            self.menuItemPreventSystemSleep.state = .off
            SSEnergyManager.shared().preventSleep(false)
        }
        _preventSleepTimer?.resume()
    }
    
    func __cancelPreventSleepTimeout() -> Void {
        if nil != _preventSleepTimer {
            _preventSleepTimer?.cancel()
            _preventSleepTimer = nil
        }
    }
}

    //MARK: Touch Bar

@available(OSX 10.12.2, *)
fileprivate extension NSTouchBar.CustomizationIdentifier {
    static let touchBar = NSTouchBar.CustomizationIdentifier("com.HyperartFlow.Kaka.Touchbar.KakaWnd")
}

@available(OSX 10.12.2, *)
fileprivate extension NSTouchBarItem.Identifier {
    static let displayDesktop = NSTouchBarItem.Identifier("com.HyperartFlow.Kaka.TouchbarItem.displayDesktop")
    static let hideDesktopIcon = NSTouchBarItem.Identifier("com.HyperartFlow.Kaka.TouchbarItem.hideDesktopIcon")
    static let turnOnDarkMode = NSTouchBarItem.Identifier("com.HyperartFlow.Kaka.TouchbarItem.turnOnDarkMode")
}

extension HAFKakaWindowController: NSTouchBarDelegate {
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBar
        touchBar.defaultItemIdentifiers = [.displayDesktop,.hideDesktopIcon,.turnOnDarkMode]
        touchBar.customizationAllowedItemIdentifiers = [.displayDesktop,.hideDesktopIcon,.turnOnDarkMode]
        return touchBar
    }
    
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let custom = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case NSTouchBarItem.Identifier.displayDesktop:
            custom.customizationLabel = "Display Desktop"
            var title: String = "👀 "
            title = title.appending(NSLocalizedString("Display Desktop", comment: ""))
            let button = NSButton(title: title, target: self, action: #selector(showDesktopMenuItem_click))
            custom.view = button
            return custom
            
        case NSTouchBarItem.Identifier.hideDesktopIcon:
            custom.customizationLabel = "Hide Desktop Icons"
            var title: String = "🙈 "
            title = title.appending(NSLocalizedString("Hide Desktop Icons", comment: ""))
            let button = NSButton(title: title, target: self, action: #selector(showDesktopIconMenuItem_click))
            custom.view = button
            return custom
            
        case NSTouchBarItem.Identifier.turnOnDarkMode:
            custom.customizationLabel = "Turn On Dark Mode"
            var title: String = "🌙 "
            title = title.appending(NSLocalizedString("Turn On Dark Mode", comment: ""))
            let button = NSButton(title: title, target: self, action: #selector(turnOnDarkModeMenuItem_click))
            custom.view = button
            return custom
            
        default:
            return custom
        }
    }
}

