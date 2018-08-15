//
//  HAFKakaObject.swift
//  Kaka
//
//  Created by Jovi on 8/12/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

enum UserActionType: Int {
    case eInvalidAction = 0
    case eLeftBtnClick
    case eRightBtnClick
    case eDoubleClick
    case eDragToRightMargin
    case eDragFromRightMargion
    case eDragToTopMargin
    case eDragFromTopMargin
}

enum KakaStateType {
    case eKakaStateNormal
    case eKakaStateDragging
    case eKakaStateHidden
}

class HAFKakaObject: NSObject {
    var _state: KakaStateType
    var _nextAction: UserActionType
    var _animationSequence: HAFAnimationSequence?
    var _nextAnimationSequence: HAFAnimationSequence?
    var _nCurrentFrameCount: Int
    var _nCurrentFrameIndex: Int
    
    override init() {
        _state = .eKakaStateNormal
        _nextAction = .eInvalidAction
        _nextAnimationSequence = nil
        _animationSequence = HAFAnimationManager.sharedManager.happy
        _nCurrentFrameCount = _animationSequence!.frameCount()
        _nCurrentFrameIndex = 0
        super.init()
    }
    
    func doAction(actionType: UserActionType) -> Void {
        if .eInvalidAction == _nextAction{
            _nextAction = actionType
        }
    }
    
    func currentAnimationFrame() -> NSImage? {
        if nil != _animationSequence && _nCurrentFrameIndex < _nCurrentFrameCount {
            return _animationSequence!.frameAtIndex(_nCurrentFrameIndex)
        }
        return nil
    }
    
    func moveToNextAnimationFrame() -> Void {
        _nCurrentFrameIndex += 1;
        if _nCurrentFrameIndex < _nCurrentFrameCount {
            return;
        }
        
        if nil != _animationSequence!.nextAnimationSequence{
            _animationSequence = _animationSequence!.nextAnimationSequence
        }else{
            if nil == _nextAnimationSequence{
                _animationSequence = HAFAnimationManager.sharedManager.randomAnimationSequence()
            }else{
                _animationSequence = _nextAnimationSequence
                _nextAnimationSequence = nil;
            }
        }
        _nCurrentFrameCount = _animationSequence!.frameCount()
        _nCurrentFrameIndex = 0
    }
}
