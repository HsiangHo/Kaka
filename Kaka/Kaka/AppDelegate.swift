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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

