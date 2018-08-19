//
//  HAFKakaWindowController.swift
//  Kaka
//
//  Created by Jovi on 8/19/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFKakaWindowController: NSWindowController {
    var view: HAFAnimationView!
    var _kakaObj: HAFKakaObject? = nil
    
    init() {
        let frame = NSMakeRect(0, 0, 215, 170)
        let wnd = HAFAnimationWindow.init(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
        wnd.contentView = HAFTransparentView.init(frame: frame)
        view = HAFAnimationView.init(frame: frame)
        wnd.contentView?.addSubview(view)
        super.init(window: wnd)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setKakaObject(kakaObj: HAFKakaObject) -> Void {
        _kakaObj = kakaObj
        view.setKakaObj(_kakaObj!)
        view.startToPlay()
    }

}
