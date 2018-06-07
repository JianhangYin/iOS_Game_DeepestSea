//
//  GameScene_Select.swift
//  DeepestSea
//
//  Created by Jianhang Yin on 6/5/18.
//  Copyright © 2018 Jianhang. All rights reserved.
//

import SpriteKit
import GameplayKit

var playerType = 0

class GameScene_Select: SKScene {
    
    let startLabel = SKLabelNode(fontNamed: "RussoOne-Regular")
    let ownNode1 = SKSpriteNode(imageNamed: "own")
    let ownNode2 = SKSpriteNode(imageNamed: "own")
    let ownNode3 = SKSpriteNode(imageNamed: "own")
    
    let clickSound = SKAction.playSoundFileNamed("click.mp3", waitForCompletion: false)

    
    override func didMove(to view: SKView) {
        
        initialization()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startgame(touches: touches)
    }
    
    func initialization() {
        
        let backGround = SKSpriteNode(imageNamed: "background")
        backGround.name = "Background"
        backGround.size = self.size
        backGround.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        backGround.zPosition = 0
        self.addChild(backGround)
        
        ownNode1.setScale(0)
        ownNode1.position = CGPoint(x: self.size.width * 0.55, y: self.size.height * 0.80)
        ownNode1.zPosition = 2
        self.addChild(ownNode1)
        
        ownNode2.setScale(0)
        ownNode2.position = CGPoint(x: self.size.width * 0.55, y: self.size.height * 0.50)
        ownNode2.zPosition = 2
        self.addChild(ownNode2)
        
        ownNode3.setScale(0)
        ownNode3.position = CGPoint(x: self.size.width * 0.55, y: self.size.height * 0.20)
        ownNode3.zPosition = 2
        self.addChild(ownNode3)
        
        let selectGround = SKSpriteNode(imageNamed: "select")
        selectGround.name = "Selectground"
        selectGround.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        selectGround.zPosition = 1
        self.addChild(selectGround)
        
    }
    
    func startgame(touches: Set<UITouch>) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let waitTime = SKAction.wait(forDuration: 1)
            let scaleIn = SKAction.scale(to: 1.2, duration: 0.5)
            let scaleOut = SKAction.scale(to: 1, duration: 0.1)
            let scaleSequence = SKAction.sequence([clickSound, scaleIn, scaleOut, waitTime])
            
            if location.y > self.size.height * 0.00 && location.y < self.size.height * 0.33 {
                playerType = 3
                ownNode3.run(scaleSequence) {
                    self.changeScene()
                }
            }
            if location.y > self.size.height * 0.33 && location.y < self.size.height * 0.66 {
                playerType = 2
                ownNode2.run(scaleSequence) {
                    self.changeScene()
                }

            }
            if location.y > self.size.height * 0.66 && location.y < self.size.height * 1.00 {
                playerType = 1
                ownNode1.run(scaleSequence) {
                    self.changeScene()
                }

            }
        }
        
    }
    
    func changeScene() {
        let targetscene = GameScene_Field(size: self.size)
        targetscene.scaleMode = self.scaleMode
        let scenetransition = SKTransition.fade(withDuration: 0.2)
        self.view!.presentScene(targetscene, transition: scenetransition)
        view?.showsPhysics = true
    }
    
    
}
