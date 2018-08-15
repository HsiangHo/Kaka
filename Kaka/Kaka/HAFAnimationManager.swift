//
//  HAFAnimationManager.swift
//  Kaka
//
//  Created by Jovi on 8/11/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

import Cocoa

class HAFAnimationManager: NSObject {
    static let sharedManager = HAFAnimationManager()
    
    var arrogance: HAFAnimationSequence;
    var bomb: HAFAnimationSequence;
    var bye: HAFAnimationSequence;
    var drag1: HAFAnimationSequence;
    var drag2: HAFAnimationSequence;
    var drag3: HAFAnimationSequence;
    var eatWatermelon: HAFAnimationSequence;
    var grimace: HAFAnimationSequence;
    var happy: HAFAnimationSequence;
    var hidden1: HAFAnimationSequence;
    var hidden2: HAFAnimationSequence;
    var hidden3: HAFAnimationSequence;
    var hidden4: HAFAnimationSequence;
    var hidden5: HAFAnimationSequence;
    var knife1: HAFAnimationSequence;
    var knife2: HAFAnimationSequence;
    var knife3: HAFAnimationSequence;
    var scan1: HAFAnimationSequence;
    var scan2: HAFAnimationSequence;
    var scan3: HAFAnimationSequence;
    var scissor: HAFAnimationSequence;
    var scratchHead: HAFAnimationSequence;
    var showTip: HAFAnimationSequence;
    var sleep1: HAFAnimationSequence;
    var sleep2: HAFAnimationSequence;
    var sleep3: HAFAnimationSequence;
    var smog1: HAFAnimationSequence;
    var smog2: HAFAnimationSequence;
    var stand: HAFAnimationSequence;
    
    var randomAnimationSequenceArray: Array<HAFAnimationSequence> = Array<HAFAnimationSequence>()
    
    init(animationDir: String = Bundle.main.bundlePath.appending("/Contents/Resources/Animations")) {
        arrogance = HAFAnimationSequence.init(animationDir.appending("/Arrogance"), animationName: "Arrogance")
        bomb = HAFAnimationSequence.init(animationDir.appending("/Bomb"), animationName: "Bomb")
        bye = HAFAnimationSequence.init(animationDir.appending("/Bye"), animationName: "Bye")
        drag1 = HAFAnimationSequence.init(animationDir.appending("/Drag1"), animationName: "Drag1")
        drag2 = HAFAnimationSequence.init(animationDir.appending("/Drag2"), animationName: "Drag2")
        drag3 = HAFAnimationSequence.init(animationDir.appending("/Drag3"), animationName: "Drag3")
        eatWatermelon = HAFAnimationSequence.init(animationDir.appending("/EatWatermelon"), animationName: "EatWatermelon")
        grimace = HAFAnimationSequence.init(animationDir.appending("/Grimace"), animationName: "Grimace")
        happy = HAFAnimationSequence.init(animationDir.appending("/Happy"), animationName: "Happy")
        hidden1 = HAFAnimationSequence.init(animationDir.appending("/Hidden1"), animationName: "Hidden1")
        hidden2 = HAFAnimationSequence.init(animationDir.appending("/Hidden2"), animationName: "Hidden2")
        hidden3 = HAFAnimationSequence.init(animationDir.appending("/Hidden3"), animationName: "Hidden3")
        hidden4 = HAFAnimationSequence.init(animationDir.appending("/Hidden4"), animationName: "Hidden4")
        hidden5 = HAFAnimationSequence.init(animationDir.appending("/Hidden5"), animationName: "Hidden5")
        knife1 = HAFAnimationSequence.init(animationDir.appending("/Knife1"), animationName: "Knife1")
        knife2 = HAFAnimationSequence.init(animationDir.appending("/Knife2"), animationName: "Knife2")
        knife1.nextAnimationSequence = knife2
        knife3 = HAFAnimationSequence.init(animationDir.appending("/Knife3"), animationName: "Knife3")
        knife2.nextAnimationSequence = knife3
        scan1 = HAFAnimationSequence.init(animationDir.appending("/Scan1"), animationName: "Scan1")
        scan2 = HAFAnimationSequence.init(animationDir.appending("/Scan2"), animationName: "Scan2")
        scan1.nextAnimationSequence = scan2
        scan3 = HAFAnimationSequence.init(animationDir.appending("/Scan3"), animationName: "Scan3")
        scan2.nextAnimationSequence = scan3
        scissor = HAFAnimationSequence.init(animationDir.appending("/Scissor"), animationName: "Scissor")
        scratchHead = HAFAnimationSequence.init(animationDir.appending("/ScratchHead"), animationName: "ScratchHead")
        showTip = HAFAnimationSequence.init(animationDir.appending("/ShowTip"), animationName: "ShowTip")
        sleep1 = HAFAnimationSequence.init(animationDir.appending("/Sleep1"), animationName: "Sleep1")
        sleep2 = HAFAnimationSequence.init(animationDir.appending("/Sleep2"), animationName: "Sleep2")
        sleep1.nextAnimationSequence = sleep2
        sleep3 = HAFAnimationSequence.init(animationDir.appending("/Sleep3"), animationName: "Sleep3")
        sleep2.nextAnimationSequence = sleep3
        smog1 = HAFAnimationSequence.init(animationDir.appending("/Smog1"), animationName: "Smog1")
        smog2 = HAFAnimationSequence.init(animationDir.appending("/Smog2"), animationName: "Smog2")
        smog1.nextAnimationSequence = smog2
        stand = HAFAnimationSequence.init(animationDir.appending("/Stand"), animationName: "Stand")
        
        randomAnimationSequenceArray.append(arrogance)
        randomAnimationSequenceArray.append(bomb)
        randomAnimationSequenceArray.append(eatWatermelon)
        randomAnimationSequenceArray.append(grimace)
        randomAnimationSequenceArray.append(happy)
        randomAnimationSequenceArray.append(scissor)
        randomAnimationSequenceArray.append(scratchHead)
        randomAnimationSequenceArray.append(showTip)
        randomAnimationSequenceArray.append(knife1)
        randomAnimationSequenceArray.append(scan1)
        randomAnimationSequenceArray.append(sleep1)
        randomAnimationSequenceArray.append(smog1)
        super.init()
    }
    
    func randomAnimationSequence() -> HAFAnimationSequence {
        let index:Int = Int(arc4random_uniform(UInt32(randomAnimationSequenceArray.count)))
        return randomAnimationSequenceArray[index]
    }
}
