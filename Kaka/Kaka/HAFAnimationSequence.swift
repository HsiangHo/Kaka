//
//  HAFAnimationSequence.swift
//  Kaka
//
//  Created by Jovi on 8/8/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFAnimationSequence: NSObject {
    private var _animationFilePath : String
    private var _animationFrameArray : [NSImage?]?
    private var _animationName: String
    
    init(_ aFilePath : String, animationName: String) {
        _animationFilePath = aFilePath
        _animationName = animationName
        super.init()
        loadResources()
    }
    
    func name() -> String {
        return _animationName
    }
    
    func frameCount() -> Int{
        if nil == _animationFrameArray {
            return 0
        }
        return _animationFrameArray!.count;
    }
    
    func frameAtIndex(_ index: Int) -> NSImage? {
        if nil == _animationFrameArray || index >= _animationFrameArray!.count {
            return nil;
        }
        return _animationFrameArray![index]
    }
    
    private func loadResources() -> Void {
        let files = try? FileManager.default.contentsOfDirectory(atPath: _animationFilePath)
        if nil == files{
            return;
        }
        
        var nCount: Int = 0
        for file in files!{
            let index = fileName2FrameIndex(path: file)
            nCount = nCount < (index + 1) ? (index + 1) : nCount
        }
        
        _animationFrameArray = [NSImage?](repeatElement(nil, count: nCount))
        for file in files!{
            let index = fileName2FrameIndex(path: file)
            if -1 != index{
                _animationFrameArray![index] = NSImage.init(contentsOfFile: _animationFilePath.appendingFormat("/%@", file))
            }
        }
        
        var lastFrame: NSImage? = nil
        var index: Int = 0
        while index < _animationFrameArray!.count {
            if nil == _animationFrameArray![index]{
                _animationFrameArray![index] = lastFrame
            }else{
                lastFrame = _animationFrameArray![index]
            }
            index += 1
        }
    }
    
    func fileName2FrameIndex(path:String) -> Int {
        var nRslt:Int = -1
        let range = path.range(of:".", options: .backwards)
        if nil != range{
            let fileIndex = Int(path[path.startIndex..<range!.lowerBound])
            if nil != fileIndex{
                nRslt = fileIndex! - 1
            }
        }
        return nRslt
    }
}
