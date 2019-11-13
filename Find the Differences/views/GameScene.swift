//
//  GameScene.swift
//  Find the Differences
//
//  Created by Araib on 13/11/2019.
//  Copyright © 2019 Woody Apps. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameViewController : GameViewController?
      
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.white
               // Get label node from scene and store it for use later
        self.anchorPoint =  CGPoint.init(x: 0.5, y: 0.5)
               
        // Get label node from scene and store it for use later
        gameViewController?.createGamePlay()
    }
    func launchGame (count : Int) {
        
    }
    
   
}
