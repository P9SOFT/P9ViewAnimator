//
//  SimpleFrameAnimationScene.swift
//
//
//  Created by Tae Hyun Na on 2016. 3. 16.
//  Copyright (c) 2014, P9 SOFT, Inc. All rights reserved.
//
//  Licensed under the MIT license.

import UIKit
import SpriteKit

class SimpleFrameAnimationScene: SKScene {
    
    var texture:SKTexture?
    var node:SKSpriteNode?
    var action:SKAction?
    
    override func didMove(to view:SKView) {
        
        super.didMove(to: view)
        
        self.scaleMode = .aspectFill
        self.backgroundColor = UIColor.clear
    }
    
    func load(_ spriteImage:UIImage!, frames:[String]!, timePerFrame:TimeInterval!) -> Bool {
        
        if (spriteImage == nil) || (frames.count == 0) {
            return false
        }
        self.texture = SKTexture(image:spriteImage)
        if self.texture == nil {
            return false
        }
        var list:[SKTexture]! = []
        for frameString in frames {
            let parameters = frameString.components(separatedBy: ":")
            let x = CGFloat((parameters[0] as NSString).floatValue)
            let y = CGFloat((parameters[1] as NSString).floatValue)
            let w = CGFloat((parameters[2] as NSString).floatValue)
            let h = CGFloat((parameters[3] as NSString).floatValue)
            let t = SKTexture(rect:CGRect(x:x,y:y,width:w,height:h), in:self.texture!)
            if list.count == 0 {
                self.node = SKSpriteNode(texture:t)
            }
            list.append(t)
        }
        if node == nil {
            return false
        }
        self.action = SKAction.animate(with: list, timePerFrame:timePerFrame)
        self.node!.size = self.size
        self.node!.position = CGPoint(x:0.5, y:0.5)
        self.addChild(self.node!)
        
        return true
    }
    
    func setRelativeVelocity(_ relativeVelocity:CGFloat) {
        
        if let action = self.action {
            action.speed = relativeVelocity
        }
    }
    
    func setZRotationOfSprite(_ zRotation:CGFloat) {
        
        node?.zRotation = zRotation
    }
    
    func play() {
        
        if let action = self.action {
            self.node?.run(action)
        }
    }
    
    func stop() {
        
        self.node?.removeAllActions()
    }
}
