//
//  HAFAppAppearanceWindowController.swift
//  Kaka
//
//  Created by Jovi on 11/8/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFAppAppearanceWindowController: NSWindowController {
    var _lbTitle: NSTextField?
    var _lbSubTitle: NSTextField?
    var _scrollerView: NSScrollView?
    var _collectionView: NSCollectionView?
    
    init() {
        let windowFrame = NSMakeRect(0, 0, 610, 720)
        let wnd = NSWindow.init(contentRect: windowFrame, styleMask: [.titled, .closable, .fullSizeContentView], backing: .buffered, defer: false)
        wnd.titlebarAppearsTransparent = true
        wnd.standardWindowButton(.zoomButton)?.isHidden = true
        wnd.standardWindowButton(.miniaturizeButton)?.isHidden = true
        wnd.title = NSLocalizedString("", comment: "")
        super.init(window: wnd)
        
        _lbTitle = NSTextField.init(frame: NSMakeRect(20, 655, 600, 30))
        _lbTitle?.stringValue = NSLocalizedString("Custom Application Appearance", comment: "")
        _lbTitle?.isEditable = false
        _lbTitle?.isSelectable = false
        _lbTitle?.isBezeled = false
        _lbTitle?.drawsBackground = false
        _lbTitle?.font = NSFont.init(name: "Helvetica Neue", size: 25)
        wnd.contentView?.addSubview(_lbTitle!)
        
        _lbSubTitle = NSTextField.init(frame: NSMakeRect(20,595, 600, 30))
        _lbSubTitle?.stringValue = "⭐️" + NSLocalizedString("Relaunch the target application takes effect.(some of applications are not supported)", comment: "")
        _lbSubTitle?.isEditable = false
        _lbSubTitle?.isSelectable = false
        _lbSubTitle?.isBezeled = false
        _lbSubTitle?.drawsBackground = false
        _lbSubTitle?.font = NSFont.init(name: "Helvetica Neue", size: 13)
        wnd.contentView?.addSubview(_lbSubTitle!)
        
        _scrollerView = NSScrollView.init(frame: NSMakeRect(20, 0, 600, 600))
        _scrollerView?.backgroundColor = NSColor.clear
        _scrollerView?.drawsBackground = false
        wnd.contentView?.addSubview(_scrollerView!)
        
        _collectionView = NSCollectionView.init(frame: NSMakeRect(0, 0, 600, 600))
        _collectionView?.backgroundColors = [NSColor.clear]
        _collectionView?.itemPrototype = HAFAppAppearanceCollectionViewItem.init()
        
        let applicationFolderPath = "/Applications/"
        let apps = try? FileManager.default.contentsOfDirectory(atPath: applicationFolderPath)
        if nil != apps {
            var appPaths = [String]();
            for appPackageName in apps! {
                let path = applicationFolderPath + appPackageName
                if !appPackageName.lowercased().hasSuffix(".app"){
                    let subPaths = appsAtFolder(folderPath: path + "/")
                    if subPaths.count > 0{
                        appPaths.append(contentsOf: subPaths)
                    }
                    continue
                }
                appPaths.append(path)
            }
            _collectionView?.content = appPaths
        }
        _scrollerView?.documentView = _collectionView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func appsAtFolder(folderPath: String) -> [String] {
        let apps = try? FileManager.default.contentsOfDirectory(atPath: folderPath)
        var appPaths = [String]();
        if nil != apps {
            for appPackageName in apps! {
                if !appPackageName.lowercased().hasSuffix(".app"){
                    continue
                }
                let path = folderPath + appPackageName
                appPaths.append(path)
            }
        }
        return appPaths
    }
}
