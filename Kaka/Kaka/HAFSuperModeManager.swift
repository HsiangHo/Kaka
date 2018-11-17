//
//  HAFSuperModeManager.swift
//  Kaka
//
//  Created by Jovi on 11/17/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

let SuperModeTime: String = "16-11-2018"  //dd-mm-yyyy

class HAFSuperModeManager: NSObject {
    static func isKakaInSuperMode() -> Bool {
        var bRslt = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        guard let date = dateFormatter.date(from: SuperModeTime) else {
            return bRslt
        }
        let dateNow = Date()
        if .orderedDescending == dateNow.compare(date) {
            bRslt = true
        }
        return bRslt
    }
}
