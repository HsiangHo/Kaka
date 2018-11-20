//
//  HAFAppApprearanceButton.swift
//  Kaka
//
//  Created by Jovi on 11/9/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

let buttonFont11 = NSFont.init(name: "Helvetica Neue", size: 11)
let buttonFont16 = NSFont.init(name: "Helvetica Neue", size: 16)

class HAFAppAppearanceButton: NSButton {
    var _appPath: NSString?
    var _appBundleID: NSString?
    var _appIcon: NSImage?
    var _appName: NSString?
    var _ivAppIcon: NSImageView?
    var _lbAppName: NSTextField?
    var _lbAppAppearance: NSTextField?
    var _btnAppReset: NSButton?
    var _trackArea: NSTrackingArea?
    
    var _bAppAppearanceFlag: Bool = true //Only available in No-superMode
    
    static func defaultButton() -> HAFAppAppearanceButton{
        return HAFAppAppearanceButton.init(frame: NSMakeRect(0, 0, 128, 128))
    }
    
    var appPath: NSString?{
        set{
            _appPath = newValue
            __updateAppInfo()
            __setupUI()
        }
        get{
            return _appPath
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        self.layer?.cornerRadius = 10.0
        self.layer?.borderColor = NSColor.lightGray.cgColor
        self.layer?.borderWidth = 1.0
        self.title = ""
        self.bezelStyle = .regularSquare
        self.target = self
        self.action = #selector(selfBtn_click)
        _ivAppIcon = NSImageView.init(frame: NSMakeRect(10, 10, 32, 32))
        self.addSubview(_ivAppIcon!)
        _lbAppName = NSTextField.init(frame: NSMakeRect(10, 54, 108, 46))
        _lbAppName?.isBezeled = false
        _lbAppName?.isEditable = false
        _lbAppName?.isSelectable = false
        _lbAppName?.lineBreakMode = .byCharWrapping
        _lbAppName?.backgroundColor = NSColor.clear
        _lbAppName?.font = buttonFont16
        self.addSubview(_lbAppName!)
        _lbAppAppearance = NSTextField.init(frame: NSMakeRect(10, 100, 120, 16))
        _lbAppAppearance?.isBezeled = false
        _lbAppAppearance?.isEditable = false
        _lbAppAppearance?.isSelectable = false
        _lbAppAppearance?.stringValue = ""
        _lbAppAppearance?.backgroundColor = NSColor.clear
        _lbAppAppearance?.font = buttonFont11
        _lbAppAppearance?.textColor = NSColor.init(calibratedRed: 232/255.0, green: 136/255.0, blue: 58/255.0, alpha: 1.0)
        self.addSubview(_lbAppAppearance!)
        
        _btnAppReset = NSButton.init(frame: NSMakeRect(104, 8, 16, 16))
        _btnAppReset?.bezelStyle = .regularSquare
        _btnAppReset?.title = ""
        _btnAppReset?.isHidden = true
        _btnAppReset?.target = self
        _btnAppReset?.action = #selector(resetBtn_click)
        self.addSubview(_btnAppReset!)
        
        __setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @available(OSX 10.14, *)
    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        __setupUI()
    }
    
    func __updateAppInfo() -> Void {
        if nil == _appPath {
            return
        }
        let bundle = Bundle.init(path: _appPath! as String)
        if nil == bundle || nil == bundle!.bundleIdentifier {
            return
        }
        
        _appBundleID = bundle!.bundleIdentifier! as NSString
        _appIcon = NSWorkspace.shared.icon(forFile: _appPath! as String)
        _appName = bundle!.infoDictionary?[kCFBundleNameKey as String] as? NSString
    }
    
    override func draw(_ dirtyRect: NSRect) {

    }
    
    override func updateTrackingAreas() {
        if nil != _trackArea {
            self.removeTrackingArea(_trackArea!)
        }
        _trackArea = NSTrackingArea.init(rect: self.bounds, options: [.mouseMoved, .mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(_trackArea!)
    }
    
    override func mouseEntered(with event: NSEvent) {
        _btnAppReset?.isHidden = false
    }
    
    override func mouseExited(with event: NSEvent) {
        _btnAppReset?.isHidden = true
    }
    
    func __notSupportedAlert() -> NSAlert {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Not supported", comment: "")
        alert.informativeText = NSLocalizedString("To custom app appearance needs macOS 10.14 and later.", comment: "")
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        return alert
    }
    
    @IBAction func selfBtn_click(sender: AnyObject?){
        if #available(OSX 10.14, *) {} else{
            let alert = __notSupportedAlert()
            alert.runModal()
            return;
        }
        if nil == _appBundleID {
            return
        }
        if !HAFSuperModeManager.isKakaInSuperMode() {
            self.__setupUI()
            return;
        }
        SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
            let appAppearance = SSAppearanceManager.shared()?.appAppearance(self._appBundleID! as String)
            if eAppLightkAppearance == appAppearance || (eAppSystemAppearence == appAppearance && !SSAppearanceManager.shared()!.isDarkMode()){
                SSAppearanceManager.shared()?.setAppAppearance(eAppDarkAppearance, withBundleID: self._appBundleID as String?)
            }else if eAppDarkAppearance == appAppearance || (eAppSystemAppearence == appAppearance && SSAppearanceManager.shared()!.isDarkMode()){
                SSAppearanceManager.shared()?.setAppAppearance(eAppLightkAppearance, withBundleID: self._appBundleID as String?)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
                self.__setupUI()
            })
        }
    }
    
    @IBAction func resetBtn_click(sender: AnyObject?){
        if #available(OSX 10.14, *) {} else{
            let alert = __notSupportedAlert()
            alert.runModal()
            return;
        }
        if nil == _appBundleID {
            return
        }
        if !HAFSuperModeManager.isKakaInSuperMode() {
            return;
        }
        SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
            let appAppearance = SSAppearanceManager.shared()?.appAppearance(self._appBundleID! as String)
            if eAppSystemAppearence != appAppearance{
                SSAppearanceManager.shared()?.setAppAppearance(eAppSystemAppearence, withBundleID: self._appBundleID as String?)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
                    self.__setupUI()
                })
            }
        }
    }
    
    private func __setupDarkUI(){
        self._lbAppAppearance?.stringValue = "Dark Appearace"
        self._lbAppName?.textColor = NSColor.white
        self.layer?.backgroundColor = NSColor.init(calibratedRed: 49/255.0, green: 50/255.0, blue: 52/255.0, alpha: 1.0).cgColor
    }
    
    private func __setupLightUI(){
        self._lbAppAppearance?.stringValue = "Light Appearace"
        self._lbAppName?.textColor = NSColor.init(calibratedRed: 38/255.0, green: 38/255.0, blue: 38/255.0, alpha: 1.0)
        self.layer?.backgroundColor = NSColor.init(calibratedRed: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0).cgColor
    }
    
    private func __setupUI(){
        if nil != _appName {
            var title: NSString = _appName!
            let paragraphStype = NSMutableParagraphStyle.init()
            paragraphStype.lineBreakMode = .byCharWrapping
            var appNameSize = _lbAppName!.frame.size
            appNameSize.width *= 0.97
            let rct = title.boundingRect(with: appNameSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: buttonFont16!, NSAttributedStringKey.paragraphStyle: paragraphStype])
            if rct.size.height <= 23 {
                title = NSString.init(format: "\n%@", title)
            }
            _lbAppName?.stringValue = title as String
        }else{
            _lbAppName?.stringValue = ""
        }
        _ivAppIcon?.image = _appIcon
        
        if !HAFSuperModeManager.isKakaInSuperMode() {
            if _bAppAppearanceFlag{
                __setupDarkUI()
            }else{
                __setupLightUI()
            }
            _bAppAppearanceFlag = !_bAppAppearanceFlag
            return;
        }
        
        if nil != _appBundleID {
            SSUtility.accessFilePath(URL.init(fileURLWithPath: "/"), persistPermission: true, withParentWindow: nil) {
                let appAppearance = SSAppearanceManager.shared()?.appAppearance(self._appBundleID! as String)
                if eAppLightkAppearance == appAppearance{
                    self.__setupLightUI()
                }else if eAppDarkAppearance == appAppearance{
                    self.__setupDarkUI()
                }else if eAppSystemAppearence == appAppearance{
                    if SSAppearanceManager.shared()!.isDarkMode(){
                        self.__setupDarkUI()
                    }else{
                        self.__setupLightUI()
                    }
                    self._lbAppAppearance?.stringValue = "System Appearace"
                }
            }
        }else{
            self._lbAppAppearance?.stringValue = ""
        }
    }
}
