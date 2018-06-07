//
//  GameScene_Menu.swift
//  DeepestSea
//
//  Created by Jianhang Yin on 6/5/18.
//  Copyright © 2018 Jianhang. All rights reserved.
//

import SpriteKit
import GameplayKit

var bestScore = 0

class GameScene_Menu: SKScene {
    
    let startLabel = SKLabelNode(fontNamed: "RussoOne-Regular")
    
    override func didMove(to view: SKView) {
        
        initialization()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startgame(touches: touches)
    }
    
    func initialization() {
        
        let defaultsBest = UserDefaults()
        let recordBest = defaultsBest.integer(forKey: "bestSaved")
        bestScore = recordBest
        
        let backGround = SKSpriteNode(imageNamed: "background")
        backGround.name = "Background"
        backGround.size = self.size
        backGround.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        backGround.zPosition = 0
        self.addChild(backGround)
        
        let gameLabel0 = SKLabelNode(fontNamed: "RussoOne-Regular")
        gameLabel0.numberOfLines = 2
        gameLabel0.text = "JIANHANG's"
        gameLabel0.fontSize = 100
        gameLabel0.fontColor = SKColor.white
        gameLabel0.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.70)
        gameLabel0.zPosition = 2
        self.addChild(gameLabel0)
        
        let gameLabel0s = SKLabelNode(fontNamed: "RussoOne-Regular")
        gameLabel0s.numberOfLines = 2
        gameLabel0s.text = "JIANHANG's"
        gameLabel0s.fontSize = 100
        gameLabel0s.fontColor = SKColor.black
        gameLabel0s.position = CGPoint(x: self.size.width / 2 - 10, y: self.size.height * 0.70 - 20)
        gameLabel0s.zPosition = 1
        self.addChild(gameLabel0s)
        
        let gameLabel1 = SKLabelNode(fontNamed: "RussoOne-Regular")
        gameLabel1.numberOfLines = 2
        gameLabel1.text = "DEEPEST"
        gameLabel1.fontSize = 200
        gameLabel1.fontColor = SKColor.white
        gameLabel1.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.60)
        gameLabel1.zPosition = 2
        self.addChild(gameLabel1)
        
        let gameLabel1s = SKLabelNode(fontNamed: "RussoOne-Regular")
        gameLabel1s.numberOfLines = 2
        gameLabel1s.text = "DEEPEST"
        gameLabel1s.fontSize = 200
        gameLabel1s.fontColor = SKColor.black
        gameLabel1s.position = CGPoint(x: self.size.width / 2 - 10, y: self.size.height * 0.60 - 20)
        gameLabel1s.zPosition = 1
        self.addChild(gameLabel1s)
        
        let gameLabel2 = SKLabelNode(fontNamed: "RussoOne-Regular")
        gameLabel2.numberOfLines = 2
        gameLabel2.text = "SEA"
        gameLabel2.fontSize = 200
        gameLabel2.fontColor = SKColor.white
        gameLabel2.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.50)
        gameLabel2.zPosition = 2
        self.addChild(gameLabel2)
        
        let gameLabel2s = SKLabelNode(fontNamed: "RussoOne-Regular")
        gameLabel2s.numberOfLines = 2
        gameLabel2s.text = "SEA"
        gameLabel2s.fontSize = 200
        gameLabel2s.fontColor = SKColor.black
        gameLabel2s.position = CGPoint(x: self.size.width / 2 - 10, y: self.size.height * 0.50 - 20)
        gameLabel2s.zPosition = 1
        self.addChild(gameLabel2s)
        
        let bestLabel = SKLabelNode(fontNamed: "RussoOne-Regular")
        bestLabel.text = "BEST: \(bestScore)"
        bestLabel.fontSize = 150
        bestLabel.fontColor = SKColor.white
        bestLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.3)
        bestLabel.zPosition = 2
        self.addChild(bestLabel)
        
        let bestLabels = SKLabelNode(fontNamed: "RussoOne-Regular")
        bestLabels.text = "BEST: \(bestScore)"
        bestLabels.fontSize = 150
        bestLabels.fontColor = SKColor.black
        bestLabels.position = CGPoint(x: self.size.width / 2 - 15, y: self.size.height * 0.3 - 15)
        bestLabels.zPosition = 1
        self.addChild(bestLabels)
        
        startLabel.text = "START"
        startLabel.fontSize = 150
        startLabel.fontColor = SKColor.white
        startLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.15)
        startLabel.zPosition = 2
        self.addChild(startLabel)
        
        let startLabels = SKLabelNode(fontNamed: "RussoOne-Regular")
        startLabels.text = "START"
        startLabels.fontSize = 150
        startLabels.fontColor = SKColor.black
        startLabels.position = CGPoint(x: self.size.width / 2 - 15, y: self.size.height * 0.15 - 15)
        startLabels.zPosition = 1
        self.addChild(startLabels)
        
        
    }
    
    func startgame(touches: Set<UITouch>) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if startLabel.contains(location) {
                changeScene()
            }
        }
        
    }
    
    func changeScene() {
        let targetscene = GameScene_Select(size: self.size)
        targetscene.scaleMode = self.scaleMode
        let scenetransition = SKTransition.fade(withDuration: 0.2)
        self.view!.presentScene(targetscene, transition: scenetransition)
        view?.showsPhysics = false
    }
    
    
}
