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
    var kaka: HAFKakaObject = HAFKakaObject.init()
    var kakaWindowController: HAFKakaWindowController = HAFKakaWindowController.init()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        kakaWindowController.setKakaObject(kakaObj: kaka)
        kakaWindowController.showWindow(nil)
        if HAFConfigureManager.sharedManager.isAutoHideMouseCursor() {
            SSCursorManager.shared().setAutoHideTimeout(3)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
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

