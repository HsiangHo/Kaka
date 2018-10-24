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
//    var menuItemShowHiddenFilesAndFolders: NSMenuItem!
    var menuItemTurnOffTheDisplay: NSMenuItem!
    var menuItemEnableFinderExtension: NSMenuItem!
    var menuItemTurnOnDarkMode: NSMenuItem!
    var menuItemTurnOnDarkModeBaseOnDisplayBrightness: NSMenuItem!
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
    var _updateDesktopCoverTimer: DispatchSourceTimer?
    
    init() {
        let offsetX: CGFloat = NSScreen.screens[0].frame.width - 150
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
        var turnOnDarkModeBaseOnDisplayBrightness = NSLocalizedString("Toggle Dark Mode Base On Display Brightness", comment: "")
        turnOnDarkModeBaseOnDisplayBrightness = turnOnDarkModeBaseOnDisplayBrightness.appending(String(format:" (%d%%)", arguments:[Int(HAFConfigureManager.sharedManager.autoToggleDarkModeBaseOnDisplayBrightnessValue()*100)]))
//        menuItemShowHiddenFilesAndFolders = NSMenuItem.init(title: NSLocalizedString("Show Hidden Files & Folders",comment: ""), action: #selector(showHiddenFilesAndFolders_click), keyEquivalent: "")
        menuItemTurnOffTheDisplay = NSMenuItem.init(title: NSLocalizedString("Turn Off The Display",comment: ""), action: #selector(turnOffTheDisplay_click), keyEquivalent: "")
        menuItemTurnOnDarkModeBaseOnDisplayBrightness = NSMenuItem.init(title: turnOnDarkModeBaseOnDisplayBrightness, action: #selector(turnOnDarkModeBaseOnDisplayBrightnessMenuItem_click), keyEquivalent: "")
        menuItemTurnOnDarkMode = NSMenuItem.init(title: NSLocalizedString("Turn On Dark Mode", comment: ""), action: #selector(turnOnDarkModeMenuItem_click), keyEquivalent: "")
        menuItemAutoHideMouseCursor = NSMenuItem.init(title: NSLocalizedString("Hide The Mouse Cursor Automatically", comment: ""), action: #selector(autoHideMouseCursorMenuItem_click), keyEquivalent: "")
       menuItemAutoHideDesktopIcons = NSMenuItem.init(title: NSLocalizedString("Hide Desktop Icons Automatically", comment: ""), action: #selector(autoHideDesktopIcons_click), keyEquivalent: "")
       menuItemRateOnMacAppStore = NSMenuItem.init(title: NSLocalizedString("Rate On Mac App Store", comment: ""), action: #selector(rateOnMacAppStore_click), keyEquivalent: "")
        menuItemDisplayKaka = NSMenuItem.init(title: NSLocalizedString("Display Kaka", comment: ""), action: #selector(displayKakaMenuItem_click), keyEquivalent: "")
        menuItemPreventSystemSleep = NSMenuItem.init(title: NSLocalizedString("Prevent System From Falling Asleep", comment: ""), action: #selector(preventSystemSleepMenuItem_click), keyEquivalent: "")
        menuItemShowDesktopIcon = NSMenuItem.init(title: NSLocalizedString("Hide Desktop Icons", comment: ""), action: #selector(showDesktopIconMenuItem_click), keyEquivalent: "")
        menuItemEnableFinderExtension = NSMenuItem.init(title: NSLocalizedString("Enable Finder Extension", comment: ""), action: #selector(enableFinderExtension_click), keyEquivalent: "")
        menuItemHelp = NSMenuItem.init(title: NSLocalizedString("Help", comment: ""), action: #selector(help_click), keyEquivalent: "")
        menuItemQuit = NSMenuItem.init(title: NSLocalizedString("Quit", comment: ""), action: #selector(quit_click), keyEquivalent: "q")
        
        super.init(window: wnd)
        
        menuItemAbout.target = self
        menuItemPreferences.target = self
        menuItemPreventSystemSleep.target = self
        menuItemShowDesktop.target = self
        menuItemShowDesktopIcon.target = self
        menuItemPreventSystemSleep.target = self
//        menuItemShowHiddenFilesAndFolders.target = self
        menuItemTurnOffTheDisplay.target = self
        menuItemTurnOnDarkModeBaseOnDisplayBrightness.target = self
        menuItemTurnOnDarkMode.target = self
        menuItemAutoHideMouseCursor.target = self
        menuItemAutoHideDesktopIcons.target = self
        menuItemRateOnMacAppStore.target = self
        menuItemDisplayKaka.target = self
        menuItemEnableFinderExtension.target = self
        menuItemHelp.target = self
        menuItemQuit.target = self
        
        actionMenu.addItem(menuItemShowDesktop)
        actionMenu.addItem(menuItemShowDesktopIcon)
//        actionMenu.addItem(menuItemShowHiddenFilesAndFolders)
        actionMenu.addItem(menuItemTurnOffTheDisplay)
        actionMenu.addItem(menuItemTurnOnDarkMode)
        actionMenu.addItem(NSMenuItem.separator())
        actionMenu.addItem(menuItemAutoHideMouseCursor)
        actionMenu.addItem(menuItemAutoHideDesktopIcons)
        actionMenu.addItem(menuItemPreventSystemSleep)
        actionMenu.addItem(menuItemTurnOnDarkModeBaseOnDisplayBrightness)
        actionMenu.addItem(menuItemEnableFinderExtension)
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
        
        if HAFConfigureManager.sharedManager.isEnableFinderExtension(){
            menuItemEnableFinderExtension.state = .on
            __loadFinderPlugin()
        }
        
        if HAFConfigureManager.sharedManager.isEnableKaka(){
            menuItemDisplayKaka.state = .on
            self.window?.makeKeyAndOrderFront(nil)
            _view.isVisible = true
        }else{
            menuItemDisplayKaka.state = .off
            wnd.orderOut(nil)
            _view.isVisible = false
        }
        
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
        SSDesktopManager.shared().turnOffTheDisplay()
    }
    
    @IBAction func showDesktopIconMenuItem_click(sender: AnyObject?){
        if menuItemShowDesktopIcon.state == .off {
            menuItemShowDesktopIcon.state = .on
        }else{
            menuItemShowDesktopIcon.state = .off
        }
        __showDesktopIcons()
    }
    
    @IBAction func preventSystemSleepMenuItem_click(sender: AnyObject?){
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
    
    @IBAction func enableFinderExtension_click(sender: AnyObject?){
        if menuItemEnableFinderExtension.state == .off {
            menuItemEnableFinderExtension.state = .on
            __loadFinderPlugin()
        }else{
            menuItemEnableFinderExtension.state = .off
            __unloadFinderPlugin()
        }
        HAFConfigureManager.sharedManager.setEnableFinderExtension(bFlag: menuItemEnableFinderExtension.state == .on)
    }
    
    @IBAction func rateOnMacAppStore_click(sender: AnyObject?){
        NSWorkspace.shared.open(URL.init(string: "macappstore://itunes.apple.com/app/id1434172933")!)
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
    
    //MARK: Public functions
    func updateActionMenu() -> Void{
        menuItemShowDesktopIcon.state = SSDesktopManager.shared().desktopCoverWindow().isVisible ? .on : .off
        menuItemTurnOnDarkMode.state = SSAppearanceManager.shared().isDarkMode() ? .on : .off
        var turnOnDarkModeBaseOnDisplayBrightness = NSLocalizedString("Toggle Dark Mode Base On Display Brightness", comment: "")
        turnOnDarkModeBaseOnDisplayBrightness = turnOnDarkModeBaseOnDisplayBrightness.appending(String(format:" (%d%%)", arguments:[Int(HAFConfigureManager.sharedManager.autoToggleDarkModeBaseOnDisplayBrightnessValue()*100)]))
        menuItemTurnOnDarkModeBaseOnDisplayBrightness.title = turnOnDarkModeBaseOnDisplayBrightness
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
        if SSDesktopManager.shared().desktopCoverWindow().isVisible{
            SSDesktopManager.shared().uncoverDesktop()
        }else{
            SSDesktopManager.shared().desktopCoverImageView().image = SSDesktopManager.shared().snapshotDesktopImage()
            SSDesktopManager.shared().coverDesktop()
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
            if SSDesktopManager.shared().desktopCoverWindow().isVisible{
                SSDesktopManager.shared().desktopCoverImageView().image = SSDesktopManager.shared().snapshotDesktopImage()
            }
        }
        _updateDesktopCoverTimer?.resume()
    }
    
    public func __stopToUpdateDesktopCover(){
        _updateDesktopCoverTimer?.cancel()
        _updateDesktopCoverTimer = nil
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

