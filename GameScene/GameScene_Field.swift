//
//  GameScene_Field.swift
//  DeepestSea
//
//  Created by Jianhang Yin on 6/5/18.
//  Copyright © 2018 Jianhang. All rights reserved.
//

import UIKit
import GameplayKit

var playerScore = 0
class GameScene_Field: SKScene,SKPhysicsContactDelegate {
    
    class enemySubNode: SKSpriteNode {
        
        var lifeCount = 1
        
    }
    
    var scoreLabel = SKLabelNode(fontNamed: "RussoOne-Regular")
    var lifeLabel = SKLabelNode(fontNamed: "RussoOne-Regular")
    var bombLabel = SKLabelNode(fontNamed: "RussoOne-Regular")
    var playerNode = SKSpriteNode(imageNamed: "submarine_\(playerType)")
    var buttonNode = SKSpriteNode(imageNamed: "button")
    
    let bullet1Sound = SKAction.playSoundFileNamed("bullet_1.wav", waitForCompletion: false)
    let bullet2Sound = SKAction.playSoundFileNamed("bullet_2.WAV", waitForCompletion: false)
    let bullet3Sound = SKAction.playSoundFileNamed("bullet_3.mp3", waitForCompletion: false)
    let hitSound = SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false)
    let bombSound = SKAction.playSoundFileNamed("bomb.wav", waitForCompletion: false)
    let coinSound = SKAction.playSoundFileNamed("coin.mp3", waitForCompletion: false)
    let releaseSound = SKAction.playSoundFileNamed("release.mp3", waitForCompletion: false)
    let monsterSound = SKAction.playSoundFileNamed("monster.mp3", waitForCompletion: false)

    var playerLife = 7 - 2 * playerType
    var playerBomb = 4 - playerType
    var gameLevel = 0
    
    var gameStatus = gameState.inGame
    
    struct PhysicsCategories {
        static let None:   UInt32 = 0
        static let Player: UInt32 = 1
        static let Bomb:   UInt32 = 2
        static let Bullet: UInt32 = 3
        static let Enemy:  UInt32 = 4
        static let Boss:   UInt32 = 5
        static let Gas:    UInt32 = 6
    }
    
    enum gameState {
        case inGame
        case inboss
        case afterGame
    }
    
    let gameArea: CGRect
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        initialization()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStatus == gameState.inGame || gameStatus == gameState.inboss {
            fireBomb(touches: touches)
            if playerType == 1 {
                fireBullet_1(touches: touches)
            } else if playerType == 2 {
                fireBullet_2(touches: touches)
            } else if playerType == 3 {
                fireBullet_3(touches: touches)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStatus == gameState.inGame || gameStatus == gameState.inboss {
            playerMove(touches: touches, targetNode: playerNode)
        }
    }
    
    var lastUpdateTime: TimeInterval = 0
    var deltaFrameTime: TimeInterval = 0
    let amountToMovePerSec: CGFloat = 500.0 // could be var to speed up the background
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime == 0{
            lastUpdateTime = currentTime
        } else {
            deltaFrameTime = currentTime - lastUpdateTime
            lastUpdateTime = currentTime
        }
        
        let amountToMoveBackground = amountToMovePerSec * CGFloat(deltaFrameTime)
        
        self.enumerateChildNodes(withName: "Background"){
            background, stop in
            
            if self.gameStatus == gameState.inGame || self.gameStatus == gameState.inboss {
                background.position.y -= amountToMoveBackground
            }
            if background.position.y < -self.size.height {
                background.position.y += self.size.height*2
            }
        }
        
    }

    
    func initialization() {
        
        startNewLevel()
        playerScore = 0
        
        for i in 0...1 {
            let backGround = SKSpriteNode(imageNamed: "background_new")
            backGround.name = "Background"
            backGround.size = self.size
            backGround.anchorPoint = CGPoint(x: 0.5, y: 0)
            backGround.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * CGFloat(i))
            backGround.zPosition = 0
            self.addChild(backGround)
        }
        
        playerNode.setScale(0.8)
        playerNode.position = CGPoint(x: self.size.width/2, y: playerNode.size.height)
        playerNode.zPosition = 2
        playerNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "submarine_\(playerType)"), size: CGSize(width: playerNode.size.width, height: playerNode.size.height))
        playerNode.physicsBody!.affectedByGravity = false
        playerNode.physicsBody!.categoryBitMask = PhysicsCategories.Player
        playerNode.physicsBody!.collisionBitMask = PhysicsCategories.None
        playerNode.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy | PhysicsCategories.Boss | PhysicsCategories.Gas
        self.addChild(playerNode)
        
        buttonNode.setScale(0.7)
        buttonNode.position = CGPoint(x: self.size.width * 0.3, y: self.size.height * 0.05)
        buttonNode.zPosition = 100
        self.addChild(buttonNode)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height - 3 * scoreLabel.frame.size.height)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        lifeLabel.text = "Life: \(playerLife)"
        lifeLabel.fontSize = 70
        lifeLabel.fontColor = SKColor.white
        lifeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        lifeLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height - 4.5 * lifeLabel.frame.size.height)
        lifeLabel.zPosition = 100
        self.addChild(lifeLabel)
        
        bombLabel.text = "Bomb: \(playerBomb)"
        bombLabel.fontSize = 70
        bombLabel.fontColor = SKColor.white
        bombLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        bombLabel.position = CGPoint(x: self.size.width * 0.8, y: self.size.height - 3 * bombLabel.frame.size.height)
        bombLabel.zPosition = 100
        self.addChild(bombLabel)
    }
    
    func playerMove(touches: Set<UITouch>, targetNode: SKSpriteNode) {
        for touch in touches {
            let locationOne = touch.location(in: self)
            let locationTwo = touch.previousLocation(in: self)
            let distanceX = locationOne.x - locationTwo.x
            let distanceY = locationOne.y - locationTwo.y
            targetNode.position.x += distanceX
            if targetNode.position.x > gameArea.maxX - targetNode.size.width/2 {
                targetNode.position.x = gameArea.maxX - targetNode.size.width/2
            }
            if targetNode.position.x < gameArea.minX + targetNode.size.width/2 {
                targetNode.position.x = gameArea.minX + targetNode.size.width/2
            }
            targetNode.position.y += distanceY
            if targetNode.position.y > gameArea.maxY - targetNode.size.height/2 {
                targetNode.position.y = gameArea.maxY - targetNode.size.height/2
            }
            if targetNode.position.y < gameArea.minY + targetNode.size.height/2 {
                targetNode.position.y = gameArea.minY + targetNode.size.height/2
            }
            
        }
    }
    
    func fireBullet_1(touches: Set<UITouch>) {
        
        let bulletNode = SKSpriteNode(imageNamed: "bullet_1")
        bulletNode.name = "Bullet"
        bulletNode.setScale(0.2)
        bulletNode.position = playerNode.position
        bulletNode.zPosition = 1
        bulletNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bullet_1"), size: CGSize(width: bulletNode.size.width, height: bulletNode.size.height))
        bulletNode.physicsBody!.affectedByGravity = false
        bulletNode.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bulletNode.physicsBody!.collisionBitMask = PhysicsCategories.None
        bulletNode.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy | PhysicsCategories.Boss
        self.addChild(bulletNode)
        
        let moveBullet = SKAction.moveTo(y: self.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
    
        let bulletSequence = SKAction.sequence([bullet1Sound, moveBullet, deleteBullet])
        bulletNode.run(bulletSequence)
        
    }
    
    func fireBullet_2(touches: Set<UITouch>) {
        
        for i in 1...2 {
            let bulletNode = SKSpriteNode(imageNamed: "bullet_2")
            bulletNode.name = "Bullet"
            bulletNode.setScale(0.2)
            bulletNode.position = CGPoint(x: playerNode.position.x - (CGFloat(i) - 1.5) * playerNode.size.width, y: playerNode.position.y)
            bulletNode.zPosition = 1
            bulletNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bullet_2"), size: CGSize(width: bulletNode.size.width, height: bulletNode.size.height))
            bulletNode.physicsBody!.affectedByGravity = false
            bulletNode.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
            bulletNode.physicsBody!.collisionBitMask = PhysicsCategories.None
            bulletNode.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy | PhysicsCategories.Boss
            self.addChild(bulletNode)
        
            let moveBullet = SKAction.moveTo(y: self.size.height, duration: 1)
            let deleteBullet = SKAction.removeFromParent()
        
            let bulletSequence = SKAction.sequence([bullet2Sound, moveBullet, deleteBullet])
            bulletNode.run(bulletSequence)
        }
    }
    
    func fireBullet_3(touches: Set<UITouch>) {
        
        for i in -1...1 {
            let bulletNode = SKSpriteNode(imageNamed: "bullet_3")
            bulletNode.name = "Bullet"
            bulletNode.setScale(0.2)
            bulletNode.position = playerNode.position
            bulletNode.zPosition = 1
            bulletNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "bullet_3"), size: CGSize(width: bulletNode.size.width, height: bulletNode.size.height))
            bulletNode.physicsBody!.affectedByGravity = false
            bulletNode.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
            bulletNode.physicsBody!.collisionBitMask = PhysicsCategories.None
            bulletNode.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy | PhysicsCategories.Boss
            self.addChild(bulletNode)
            
            let moveBullet = SKAction.move(to: CGPoint(x: playerNode.position.x + CGFloat(i) * (self.size.height - playerNode.position.y) * 0.3, y: self.size.height), duration: TimeInterval(1 * (self.size.height - playerNode.position.y) / self.size.height))
            let deleteBullet = SKAction.removeFromParent()
            
            let bulletSequence = SKAction.sequence([bullet3Sound, moveBullet, deleteBullet])
            bulletNode.run(bulletSequence)
        }
        
    }
    
    func fireBomb(touches: Set<UITouch>) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if buttonNode.contains(location) && playerBomb > 0 {
                let bombNode = SKSpriteNode(imageNamed: "mine")
                bombNode.name = "Bomb"
                bombNode.setScale(0.8)
                bombNode.position = playerNode.position
                bombNode.zPosition = 1
                bombNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mine"), size: CGSize(width: bombNode.size.width, height: bombNode.size.height))
                bombNode.physicsBody!.affectedByGravity = false
                bombNode.physicsBody!.categoryBitMask = PhysicsCategories.Bomb
                bombNode.physicsBody!.collisionBitMask = PhysicsCategories.None
                bombNode.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy | PhysicsCategories.Boss
                self.addChild(bombNode)
                
                let moveBomb = SKAction.moveTo(y: playerNode.position.y + 200, duration: 0.5)
                let bombSequence = SKAction.sequence([moveBomb])
                bombNode.run(bombSequence)
                
                playerBomb -= 1
                
                bombLabel.text = "Bomb: \(playerBomb)"
                
                let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
                let scaleDown = SKAction.scale(to: 1, duration: 0.2)
                let scaleSequence = SKAction.sequence([releaseSound, scaleUp, scaleDown])
                bombLabel.run(scaleSequence)
            }
        }
        
    }
    
    func spawnEnemy() {
        
        let randomXStart = randomNum(num_1: gameArea.minX, num_2: gameArea.maxX)
        let randomXEnd = randomNum(num_1: gameArea.minX, num_2: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let EndPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let moveEnemy = SKAction.move(to: EndPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence1 = SKAction.sequence([moveEnemy, deleteEnemy])
        let enemySequence2 = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        
        let dx = EndPoint.x - startPoint.x
        let dy = EndPoint.y - startPoint.y
        let amounToRotate = atan2(dy, dx)

        let diceNum = randomNum(num_1: 0, num_2: 100)
        
        if diceNum <= 10 {
            let enemyNode = enemySubNode(imageNamed: "gasoline")
            enemyNode.name = "Enemy"
            enemyNode.position = startPoint
            enemyNode.zPosition = 2
            self.addChild(enemyNode)
            enemyNode.setScale(0.5)
            enemyNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "gasoline"), size: CGSize(width: enemyNode.size.width, height: enemyNode.size.height))
            enemyNode.physicsBody!.affectedByGravity = false
            enemyNode.physicsBody!.collisionBitMask = PhysicsCategories.None
            enemyNode.physicsBody!.categoryBitMask = PhysicsCategories.Gas
            enemyNode.physicsBody!.contactTestBitMask = PhysicsCategories.Player
            if gameStatus == gameState.inGame{
                enemyNode.run(enemySequence1)
            }
            enemyNode.zRotation = amounToRotate

        } else if diceNum <= 40 {
            let enemyNode = enemySubNode(imageNamed: "shark")
            enemyNode.setScale(0.8)
            enemyNode.lifeCount = 2
            enemyNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "shark"), size: CGSize(width: enemyNode.size.width, height: enemyNode.size.height))
            enemyNode.name = "Enemy"
            enemyNode.position = startPoint
            enemyNode.zPosition = 2
            self.addChild(enemyNode)
            enemyNode.physicsBody!.affectedByGravity = false
            enemyNode.physicsBody!.collisionBitMask = PhysicsCategories.None
            enemyNode.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
            enemyNode.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            if gameStatus == gameState.inGame{
                enemyNode.run(enemySequence2)
            }
            enemyNode.zRotation = amounToRotate

        } else if diceNum <= 70 {
            let enemyNode = enemySubNode(imageNamed: "monkfish")
            enemyNode.setScale(0.8)
            enemyNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monkfish"), size: CGSize(width: enemyNode.size.width, height: enemyNode.size.height))
            enemyNode.name = "Enemy"
            enemyNode.position = startPoint
            enemyNode.zPosition = 2
            self.addChild(enemyNode)
            enemyNode.physicsBody!.affectedByGravity = false
            enemyNode.physicsBody!.collisionBitMask = PhysicsCategories.None
            enemyNode.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
            enemyNode.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            if gameStatus == gameState.inGame{
                enemyNode.run(enemySequence2)
            }
            enemyNode.zRotation = amounToRotate

        } else {
            let enemyNode = enemySubNode(imageNamed: "squid")
            enemyNode.setScale(0.5)
            enemyNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "squid"), size: CGSize(width: enemyNode.size.width, height: enemyNode.size.height))
            enemyNode.name = "Enemy"
            enemyNode.position = startPoint
            enemyNode.zPosition = 2
            self.addChild(enemyNode)
            enemyNode.physicsBody!.affectedByGravity = false
            enemyNode.physicsBody!.collisionBitMask = PhysicsCategories.None
            enemyNode.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
            enemyNode.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
            
            if gameStatus == gameState.inGame{
                enemyNode.run(enemySequence2)
            }
            enemyNode.zRotation = amounToRotate

        }
        
    }
    
    func spawnExplosion(spawnPosition:CGPoint){
        
        let explosition = SKSpriteNode(imageNamed: "bomb")
        explosition.position = spawnPosition
        explosition.zPosition = 3
        explosition.setScale(0)
        self.addChild(explosition)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explositionSequence = SKAction.sequence([bombSound,scaleIn, fadeOut, delete])
        
        explosition.run(explositionSequence)
        
    }
    
    func startNewLevel(){
        
        gameLevel += 1
        
        if self.action(forKey: "spawningEnemy") != nil {
            self.removeAction(forKey: "spawningEnemy")
        }
        
        var levelDuration = TimeInterval()
        
        switch gameLevel {
        case 1:
            levelDuration = 1.2
        case 3:
            levelDuration = 1.0
        case 5:
            levelDuration = 0.8
        case 7:
            levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("Cannot find level info")
        }
        if gameLevel == 2 || gameLevel == 4 || gameLevel == 6 {
            gameStatus = gameState.inboss
            spawnBoss(lifeNum: gameLevel * 20)
        } else {
            gameStatus = gameState.inGame
            let spawn = SKAction.run(spawnEnemy)
            let waitToSpawn = SKAction.wait(forDuration: levelDuration)
            let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
            let spawnForever = SKAction.repeatForever(spawnSequence)
            self.run(spawnForever, withKey: "spawningEnemy")
        }
        
    }
    
    func spawnBoss(lifeNum: Int) {
        
        let randomX1 = randomNum(num_1: gameArea.minX, num_2: gameArea.maxX)
        let randomX2 = randomNum(num_1: gameArea.minX, num_2: gameArea.maxX)
        
        let point1 = CGPoint(x: self.size.width * 0.5, y: self.size.height * 1.2)
        let point2 = CGPoint(x: randomX1, y: self.size.height * 1.2)
        let point3 = CGPoint(x: randomX1, y: self.size.height * 0.5)
        let point4 = CGPoint(x: randomX2, y: self.size.height * 1.2)
        let point5 = CGPoint(x: randomX2, y: self.size.height * 0.5)

        let waitBoss = SKAction.wait(forDuration: 1)
        let moveBoss1 = SKAction.move(to: point2, duration: 1)
        let moveBoss2 = SKAction.move(to: point3, duration: 0.5)
        let moveBoss3 = SKAction.move(to: point2, duration: 0.5)
        let moveBoss4 = SKAction.move(to: point1, duration: 1)
        
        let moveBoss5 = SKAction.move(to: point4, duration: 1)
        let moveBoss6 = SKAction.move(to: point5, duration: 0.5)
        let moveBoss7 = SKAction.move(to: point4, duration: 0.5)
        let moveBoss8 = SKAction.move(to: point1, duration: 1)
        
        let bossSequence = SKAction.sequence([waitBoss, monsterSound, moveBoss1, waitBoss, moveBoss2, moveBoss3, waitBoss, moveBoss4, moveBoss5, waitBoss, moveBoss6, moveBoss7, waitBoss, moveBoss8])
        let bossRepeat = SKAction.repeatForever(bossSequence)
        
        let bossNode = enemySubNode(imageNamed: "boss_1")
        bossNode.lifeCount = lifeNum
        bossNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "boss_1"), size: CGSize(width: bossNode.size.width, height: bossNode.size.height))
        bossNode.physicsBody!.affectedByGravity = false
        bossNode.physicsBody!.collisionBitMask = PhysicsCategories.None
        bossNode.physicsBody!.categoryBitMask = PhysicsCategories.Boss
        bossNode.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        bossNode.name = "Boss"
        bossNode.setScale(1)
        bossNode.position = point1
        bossNode.zPosition = 2
        self.addChild(bossNode)
        
        bossNode.run(bossRepeat)
        
    }
    
    func loseALife(){
        
        playerLife -= 1
        lifeLabel.text = "Life: \(playerLife)"
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        lifeLabel.run(scaleSequence)
        
        if playerLife == 0{
            
            runGameOver()
        }
    }
    
    func addScore() {
        
        playerScore += 1
        scoreLabel.text = "Score: \(playerScore)"
        
        if playerScore == 20 || playerScore == 21 || playerScore == 50 || playerScore == 51 || playerScore == 100 || playerScore == 101 {
            startNewLevel()
        }
    }
    
    func addLife() {
        
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        
        if playerLife <= 9 {
            playerLife += 1
            lifeLabel.text = "Life: \(playerLife)"
            lifeLabel.run(scaleSequence)
        } else if gameStatus == gameState.inGame {
            playerScore += 1
            scoreLabel.text = "Score: \(playerScore)"
            scoreLabel.run(scaleSequence)

        }
    }
    
    func runGameOver(){

        gameStatus = gameState.afterGame
        recordData()
        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet"){
            bulletNode, stop in
            bulletNode.removeAllActions()
        }
        self.enumerateChildNodes(withName: "Enemy"){
            enemyNode, stop in
            enemyNode.removeAllActions()
        }
        
        let changeSceneAction = SKAction.run(changeScene)
        let watToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([watToChangeScene, changeSceneAction])
        self.run(changeSceneSequence)
        
    }
    
    func changeScene() {
        let targetscene = GameScene_Over(size: self.size)
        targetscene.scaleMode = self.scaleMode
        let scenetransition = SKTransition.fade(withDuration: 0.2)
        self.view!.presentScene(targetscene, transition: scenetransition)
        view?.showsPhysics = false
    }
    
    func randomNum(num_1: CGFloat, num_2: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(num_1 - num_2) + min(num_1, num_2)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }

        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            if body1.node != nil{
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            runGameOver()
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Boss {
            if body1.node != nil{
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil{
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            runGameOver()
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Gas {
            if body2.node?.parent != nil {
                body1.node?.run(coinSound)
                addLife()
                body2.node?.removeFromParent()
            }
        }
        
        if (body1.categoryBitMask == PhysicsCategories.Bullet || body1.categoryBitMask == PhysicsCategories.Bomb) && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            
            if body1.node?.parent != nil {
                if body1.categoryBitMask == PhysicsCategories.Bomb {
                    playerBomb += 1
                    bombLabel.text = "Bomb: \(playerBomb)"
                    
                    let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
                    let scaleDown = SKAction.scale(to: 1, duration: 0.2)
                    let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
                    bombLabel.run(scaleSequence)
                }
                if gameStatus == gameState.inGame {
                    let body2e = body2.node as! enemySubNode
                    if body2e.lifeCount == 1 {
                        addScore()
                        if body2.node != nil{
                            spawnExplosion(spawnPosition: body2.node!.position)
                        }
                        body1.node?.removeFromParent()
                        body2.node?.removeFromParent()
                    } else {
                        body2e.lifeCount -= 1
                        body2e.run(hitSound)
                        body2e.texture = SKTexture(imageNamed: "sharkangry")
                        body1.node?.removeFromParent()
                    }
                } else if gameStatus == gameState.inboss {
                    let body2e = body2.node as! enemySubNode
                    if body2e.lifeCount == 1 {
                        if body2.node != nil{
                            spawnExplosion(spawnPosition: body2.node!.position)
                        }
                        body1.node?.removeFromParent()
                        body2.node?.removeFromParent()
                    } else {
                        body2e.lifeCount -= 1
                        body2e.run(hitSound)
                        body2e.texture = SKTexture(imageNamed: "sharkangry")
                        body1.node?.removeFromParent()
                    }
                }
            }
        }
        
        if (body1.categoryBitMask == PhysicsCategories.Bullet || body1.categoryBitMask == PhysicsCategories.Bomb) && body2.categoryBitMask == PhysicsCategories.Boss {
            
            if body1.node?.parent != nil {
                if body1.categoryBitMask == PhysicsCategories.Bomb {
                    playerBomb += 1
                    bombLabel.text = "Bomb: \(playerBomb)"
                    
                    let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
                    let scaleDown = SKAction.scale(to: 1, duration: 0.2)
                    let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
                    bombLabel.run(scaleSequence)
                }
                let body2e = body2.node as! enemySubNode
                if body2e.lifeCount == 1 {
                    addScore()
                    if body2.node != nil{
                        spawnExplosion(spawnPosition: body2.node!.position)
                    }
                    body1.node?.removeFromParent()
                    body2.node?.removeFromParent()
                } else {
                    body2e.lifeCount -= 1
                    body2e.run(hitSound)
                    body1.node?.removeFromParent()
                }
            }
        }
        
    }
    
    func recordData() {
        let defaultsBest = UserDefaults()
        var recordBest = defaultsBest.integer(forKey: "bestSaved")
        if playerScore > recordBest {
            recordBest = playerScore
        }
        defaultsBest.set(recordBest, forKey: "bestSaved")
    }

}











































