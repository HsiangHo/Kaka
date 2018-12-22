//
//  AppDelegate.swift
//  Kaka
//
//  Created by Jovi on 8/7/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    var statusItem: NSStatusItem?
    var kaka: HAFKakaObject = HAFKakaObject.init()
    var kakaWindowController: HAFKakaWindowController = HAFKakaWindowController.init()
    var rateWindowController: RateWindowController?;
    var rateConfigure: RateConfigure?
    var nActionCount: Int = 0
    var appObj: AppStoreUpdateAppObject = AppStoreUpdateAppObject.init(appName: "Kaka", withAppIcon: NSImage(named: NSImage.Name(rawValue: "AppIcon")), withCurrentVersion: Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, withProductID: "1434172933")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        kakaWindowController.setKakaObject(kakaObj: kaka)
        kakaWindowController.showWindow(nil)
        
        statusItem = NSStatusBar.system.statusItem(withLength: -1)
        let statusImage = NSImage(named: NSImage.Name(rawValue: "status_icon"))
//        statusImage!.isTemplate = true
        statusImage!.size = NSMakeSize(16, 16)
        statusItem!.image = statusImage
        statusItem!.sendAction(on: [.leftMouseUp, .rightMouseUp])
        statusItem!.action = #selector(statusItem_click)
        statusItem!.target = self
        
        if HAFConfigureManager.sharedManager.isRequestRating() {
            rateConfigure = RateConfigure.init()
            rateConfigure?.name = NSLocalizedString("Love Kaka?", comment: "")
            rateConfigure?.icon = NSImage(named: NSImage.Name(rawValue: "AppIcon"))
            rateConfigure?.detailText = NSLocalizedString("We look forward to your 5-star ratings and reviews to make Kaka better and better : )\n", comment: "") + "⭐️⭐️⭐️⭐️⭐️"
            rateConfigure?.likeButtonTitle = NSLocalizedString("Rate Now!", comment: "")
            rateConfigure?.ignoreButtonTitle = NSLocalizedString("Later", comment: "")
            rateConfigure?.rateURL = URL.init(string: "macappstore://itunes.apple.com/app/id1434172933?action=write-review")
            if nil != rateConfigure{
                rateWindowController = RateWindowController.init(configure: rateConfigure!)
                rateWindowController!.setRateTimeout(30)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func requestRating() -> Void {
        nActionCount += 1;
        if HAFSuperModeManager.isKakaInSuperMode() && HAFConfigureManager.sharedManager.isRequestRating() && 0 == nActionCount % 5 {
            rateWindowController?.requestRateWindow(RateWindowPositionTopRight, withRateCompletionCallback: { (rslt) in
                if RateResultRated == rslt{
                    HAFConfigureManager.sharedManager.setRequestRating(bFlag: false)
                }
            })
        }
    }
    
    func requestUpdating() -> Void {
        AppStoreUpdateManager.shared().checkAppUpdateAsync(appObj) { (rslt, obj) in
            if rslt && !AppStoreUpdateManager.shared().isCurrentNewVersionSkipped(obj){
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    AppStoreUpdateManager.shared().requestAppUpdateWindow(obj, withCompletionCallback: { (result, _obj) in
                        switch result {
                        case AppUpdateWindowResultUpdate:
                            NSWorkspace.shared.open(URL.init(string: "macappstore://itunes.apple.com/app/id" + _obj.productID)!)
                            break
                            
                        case AppUpdateWindowResultLater:
                            break
                            
                        case AppUpdateWindowResultSkip:
                            AppStoreUpdateManager.shared().skipCurrentNewVersion(_obj)
                            break
                            
                        default:
                            break
                        }
                    })
                })
            }
        }
    }
    
    @IBAction func statusItem_click(sender: AnyObject?){
        if NSApp.currentEvent?.type == .rightMouseUp{
            preferencesMenuItem_click(sender: sender)
        }else{
            kakaWindowController.updateActionMenu()
            statusItem!.popUpMenu(kakaWindowController.actionMenu)
        }
        requestUpdating()
        requestRating()
    }
    
    @IBAction func help_click(sender: AnyObject?){
        NSWorkspace.shared.open(URL.init(string: "https://hsiangho.github.io/2018/06/13/SupportPage/")!)
    }
    
    @IBAction func aboutMenuItem_click(sender: AnyObject?){
        kakaWindowController.aboutWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func preferencesMenuItem_click(sender: AnyObject?){
        kakaWindowController.preferencesWindowController?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

