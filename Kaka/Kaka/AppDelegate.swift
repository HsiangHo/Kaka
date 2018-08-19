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
    var kaka: HAFKakaObject = HAFKakaObject.init()
    
    @IBOutlet weak var window: HAFAnimationWindow!
    @IBOutlet weak var view: HAFAnimationView!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        view.setKakaObj(kaka)
        view.startToPlay()
//        kaka.doAction(actionType: .eDragToRightMargin)
//        kaka.doAction(actionType: .eDragFromRightMargin)
//        kaka.doAction(actionType: .eInvalidAction)
//        kaka.doAction(actionType: .eInvalidAction)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

