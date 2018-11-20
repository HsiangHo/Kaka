//
//  HAFAppAppearanceCollectionViewItem.swift
//  Kaka
//
//  Created by Jovi on 11/13/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFAppAppearanceCollectionViewItem: NSCollectionViewItem {
    var _appearanceButton: HAFAppAppearanceButton!
    
    override func loadView() {
        if nil == _appearanceButton {
            _appearanceButton = HAFAppAppearanceButton.defaultButton()
            let viewFram = NSMakeRect(0, 0, NSWidth(_appearanceButton.frame) + 20, NSHeight(_appearanceButton.frame) + 20)
            self.view = NSView.init(frame: viewFram)
        }
    }
    
    override var representedObject: Any?{
        set{
            super.representedObject = newValue
            if nil != newValue {
                self.view.addSubview(_appearanceButton)
                _appearanceButton.appPath = newValue as! NSString?
            }
        }
        get{
            return super.representedObject
        }
    }
}
