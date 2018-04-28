//
//  GameScene.swift
//  Advance War
//
//  Created by Ly Paul H. on 4/6/18.
//  Copyright © 2018 Ly Paul H. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicCategories {
        static let playerCategory: UInt32 = 0x1 << 2
        static let alienCategory: UInt32 = 0x1 << 1
        static let bulletCategory: UInt32 = 0x1 << 0
    }
    
    let player = Player(hp:5)
    let enemyBoss = Enemy(hp:1000)
    
    var gameArea: CGRect
    var gameTimer:Timer!
    
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x:margin + 50, y:0, width: playableWidth, height: size.height)
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        let background = SKSpriteNode(imageNamed: "background")
        
        addChild(background)
        addChild(player.texture)
        addChild(enemyBoss.texture)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        player.texture.position = CGPoint(x: size.width/2, y: 150)
        player.texture.zPosition = 2
        enemyBoss.texture.position = CGPoint(x:size.width/2, y: 1600)
        enemyBoss.texture.zPosition = 2
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy:0)
        self.physicsWorld.contactDelegate = self
        
        /*Randomly and constantly spawn enemy for player to shoot during game time*/
        gameTimer = Timer.scheduledTimer(timeInterval: 0.20, target: self, selector: #selector(fireBeam), userInfo: nil, repeats: true)
        
    }
    
    func bulletCollided (bulletNode: SKSpriteNode, enemyNode: SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed:"Explosion")!
        explosion.position = enemyNode.position
        self.addChild(explosion)
        enemyBoss.hp -= 1
        bulletNode.removeFromParent()
        if (enemyBoss.hp == 0) {
            enemyNode.removeFromParent()
        }
        
        
        self.run(SKAction.wait(forDuration: 2)) {
            explosion.removeFromParent()
        }
    }
    
    func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.position = player.texture.position
        bullet.zPosition = 1
        
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.isDynamic = true
        
        bullet.physicsBody?.categoryBitMask = PhysicCategories.bulletCategory
        bullet.physicsBody?.contactTestBitMask = PhysicCategories.alienCategory
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([moveBullet,deleteBullet])
        bullet.run(bulletSequence)
    }
    
    @objc func fireBeam() {
        
        let texture = SKSpriteNode(imageNamed: "blueBeam")
        texture.zPosition = 2
        let randomPos = GKRandomDistribution(lowestValue :Int(gameArea.minX), highestValue: Int(gameArea.maxX))
        let currentPosition = CGFloat(randomPos.nextInt())
        
        texture.position = CGPoint(x:currentPosition,y:self.frame.size.height + texture.size.height)
        
        texture.physicsBody = SKPhysicsBody(rectangleOf: texture.size)
        texture.physicsBody?.isDynamic = true
        texture.physicsBody?.contactTestBitMask = PhysicCategories.bulletCategory
        
        texture.physicsBody?.collisionBitMask = 0
        self.addChild(texture)
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x:currentPosition, y: texture.size.height), duration: 6))
        actionArray.append(SKAction.removeFromParent())
        
        texture.run(SKAction.sequence(actionArray))
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & PhysicCategories.bulletCategory) != 0 && (secondBody.categoryBitMask & PhysicCategories.alienCategory) != 0 {
            bulletCollided(bulletNode: firstBody.node as! SKSpriteNode, enemyNode: secondBody.node as! SKSpriteNode)
        }
        
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            player.texture.position.x += amountDragged
            if player.texture.position.x > gameArea.maxX {
                player.texture.position.x = gameArea.maxX
            } else if player.texture.position.x < gameArea.minX {
                player.texture.position.x = gameArea.minX
            }
        }
    }

    
    override func update(_ currentTime: TimeInterval) {
    }
    
   
}
