//
//  HAFKakaObject.swift
//  Kaka
//
//  Created by Jovi on 8/12/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

enum UserActionType: Int {
    case eLeftBtnClick
    case eRightBtnClick
    case eDoubleClick
    case eDragToRightMargin
    case eDragFromRightMargin
    case eDragToTopMargin
    case eDragFromTopMargin
    case eExit
}

enum KakaStateType {
    case eKakaStateNormal
    case eKakaStateDragging
    case eKakaStateHidden
}

class HAFKakaObject: NSObject {
    var _state: KakaStateType
    var _animationSequence: HAFAnimationSequence?
    var _nextAnimationSequences: [HAFAnimationSequence]
    var _nCurrentFrameCount: Int
    var _nCurrentFrameIndex: Int
    var _view: HAFAnimationView?
    
    override init() {
        _state = .eKakaStateNormal
        _nextAnimationSequences = [HAFAnimationSequence]()
        _animationSequence = HAFAnimationManager.sharedManager.happy
        _nCurrentFrameCount = _animationSequence!.frameCount()
        _nCurrentFrameIndex = 0
        _view = nil
        super.init()
    }
    
    func setAnimationView(_ view: HAFAnimationView) -> Void {
        _view = view
        _view?.setKakaObj(self)
        _view?.stopPlaying()
        _view?.startToPlay()
    }
    
    func skipCurrentAnimationSequenceChain() -> Void {
        _view?.isHidden = true
        if 0 == _nextAnimationSequences.count {
            _animationSequence = randomAnimationSequence()
        }else{
            _animationSequence = _nextAnimationSequences.remove(at: 0)
        }
        _nCurrentFrameCount = _animationSequence!.frameCount()
        _nCurrentFrameIndex = 0
    }
    
    func doAction(actionType: UserActionType, clearFlag: Bool) -> Void {
        if clearFlag {
            _nextAnimationSequences.removeAll()
        }
        switch _state {
        case .eKakaStateNormal:
            handleUserActionInNormalState(actionType)
            break
            
        case .eKakaStateDragging:
            handleUserActionInDraggingState(actionType)
            break
            
        case .eKakaStateHidden:
            handleUserActionInHiddenState(actionType)
            break
        }
    }
    
    func currentAnimationFrame() -> NSImage? {
        if nil != _animationSequence && _nCurrentFrameIndex < _nCurrentFrameCount {
            return _animationSequence!.frameAtIndex(_nCurrentFrameIndex)
        }
        return nil
    }
    
    func moveToNextAnimationFrame() -> Void {
        if 0 == _nCurrentFrameIndex{
            _view?.isHidden = false
        }
        _nCurrentFrameIndex += 1;
        if _nCurrentFrameIndex < _nCurrentFrameCount {
            return;
        }
        
        if nil != _animationSequence!.nextAnimationSequence{
            _animationSequence = _animationSequence!.nextAnimationSequence
        }else{
            if 0 == _nextAnimationSequences.count {
                _animationSequence = randomAnimationSequence()
            }else{
                _animationSequence = _nextAnimationSequences.remove(at: 0)
            }
        }
        _nCurrentFrameCount = _animationSequence!.frameCount()
        _nCurrentFrameIndex = 0
    }
    
    func randomAnimationSequence() -> HAFAnimationSequence {
        var rslt = HAFAnimationManager.sharedManager.randomAnimationSequence()
        switch _state {
        case .eKakaStateNormal:
            break
        case .eKakaStateDragging:
            rslt = HAFAnimationManager.sharedManager.drag2
            break
        case .eKakaStateHidden:
            rslt = HAFAnimationManager.sharedManager.hidden1
            if 0 == arc4random_uniform(2){
                rslt = HAFAnimationManager.sharedManager.hidden3
            }
            break
        }
        return rslt
    }
    
    private func handleUserActionInNormalState(_ actionType: UserActionType) -> Void {
        switch actionType {
        case .eLeftBtnClick:
            _nextAnimationSequences.append(randomAnimationSequence())
            break
        case .eRightBtnClick:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.eatWatermelon)
            break
        case .eDoubleClick:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.grimace)
            break
        case .eDragToRightMargin:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.hidden1)
            _state = .eKakaStateHidden
            break
        case .eDragFromRightMargin:
            break
        case .eDragToTopMargin:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.drag1)
            _state = .eKakaStateDragging
            break
        case .eDragFromTopMargin:
            break
        case .eExit:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.bye)
            break
        }
    }
    
    private func handleUserActionInDraggingState(_ actionType: UserActionType) -> Void {
        switch actionType {
        case .eDragToRightMargin:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.hidden1)
            _state = .eKakaStateHidden
            break
        case .eDragFromTopMargin:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.drag3)
            _state = .eKakaStateNormal
            break
        case .eExit:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.bye)
            break
        default:
            break
        }
    }
    
    private func handleUserActionInHiddenState(_ actionType: UserActionType) -> Void {
        switch actionType {
        case .eDoubleClick:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.hidden3)
            break
        case .eDragFromRightMargin:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.hidden5)
            _state = .eKakaStateNormal
            break
        case .eDragToTopMargin:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.drag1)
            _state = .eKakaStateDragging
            break
        case .eExit:
            _nextAnimationSequences.append(HAFAnimationManager.sharedManager.bye)
            break
        default:
            break
        }
    }
}
