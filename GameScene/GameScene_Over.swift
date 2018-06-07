//
//  GameScene_Over.swift
//  DeepestSea
//
//  Created by Jianhang Yin on 6/5/18.
//  Copyright © 2018 Jianhang. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene_Over: SKScene {
    
    let restartLabel = SKLabelNode(fontNamed: "RussoOne-Regular")

    override func didMove(to view: SKView) {
        
        initialization()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        restartgame(touches: touches)
    }
    
    func initialization() {
        
        let backGround = SKSpriteNode(imageNamed: "background")
        backGround.name = "Background"
        backGround.size = self.size
        backGround.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        backGround.zPosition = 0
        self.addChild(backGround)
        
        let gameLabel1 = SKLabelNode(fontNamed: "RussoOne-Regular")
        gameLabel1.numberOfLines = 2
        gameLabel1.text = "GAME"
        gameLabel1.fontSize = 300
        gameLabel1.fontColor = SKColor.white
        gameLabel1.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.60)
        gameLabel1.zPosition = 2
        self.addChild(gameLabel1)
        
        let gameLabel1s = SKLabelNode(fontNamed: "RussoOne-Regular")
        gameLabel1s.numberOfLines = 2
        gameLabel1s.text = "GAME"
        gameLabel1s.fontSize = 300
        gameLabel1s.fontColor = SKColor.black
        gameLabel1s.position = CGPoint(x: self.size.width / 2 - 10, y: self.size.height * 0.60 - 20)
        gameLabel1s.zPosition = 1
        self.addChild(gameLabel1s)
        
        let gameLabel2 = SKLabelNode(fontNamed: "RussoOne-Regular")
        gameLabel2.numberOfLines = 2
        gameLabel2.text = "OVER"
        gameLabel2.fontSize = 300
        gameLabel2.fontColor = SKColor.white
        gameLabel2.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.45)
        gameLabel2.zPosition = 2
        self.addChild(gameLabel2)
        
        let gameLabel2s = SKLabelNode(fontNamed: "RussoOne-Regular")
        gameLabel2s.numberOfLines = 2
        gameLabel2s.text = "OVER"
        gameLabel2s.fontSize = 300
        gameLabel2s.fontColor = SKColor.black
        gameLabel2s.position = CGPoint(x: self.size.width / 2 - 10, y: self.size.height * 0.45 - 20)
        gameLabel2s.zPosition = 1
        self.addChild(gameLabel2s)
        
        let bestLabel = SKLabelNode(fontNamed: "RussoOne-Regular")
        bestLabel.text = "SCORE: \(playerScore)"
        bestLabel.fontSize = 150
        bestLabel.fontColor = SKColor.white
        bestLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.3)
        bestLabel.zPosition = 2
        self.addChild(bestLabel)
        
        let bestLabels = SKLabelNode(fontNamed: "RussoOne-Regular")
        bestLabels.text = "SCORE: \(playerScore)"
        bestLabels.fontSize = 150
        bestLabels.fontColor = SKColor.black
        bestLabels.position = CGPoint(x: self.size.width / 2 - 15, y: self.size.height * 0.3 - 15)
        bestLabels.zPosition = 1
        self.addChild(bestLabels)
        
        restartLabel.text = "RESTART"
        restartLabel.fontSize = 150
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.15)
        restartLabel.zPosition = 2
        self.addChild(restartLabel)
        
        let restartLabels = SKLabelNode(fontNamed: "RussoOne-Regular")
        restartLabels.text = "RESTART"
        restartLabels.fontSize = 150
        restartLabels.fontColor = SKColor.black
        restartLabels.position = CGPoint(x: self.size.width / 2 - 15, y: self.size.height * 0.15 - 15)
        restartLabels.zPosition = 1
        self.addChild(restartLabels)
        
    }
    
    func restartgame(touches: Set<UITouch>) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if restartLabel.contains(location) {
                changeScene()
            }
        }
        
    }
    
    func changeScene() {
        let targetscene = GameScene_Menu(size: self.size)
        targetscene.scaleMode = self.scaleMode
        let scenetransition = SKTransition.fade(withDuration: 0.2)
        self.view!.presentScene(targetscene, transition: scenetransition)
        view?.showsPhysics = false
    }
}
































