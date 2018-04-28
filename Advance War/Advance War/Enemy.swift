//
//  File.swift
//  Advance War
//
//  Created by Ly Paul H. on 4/10/18.
//  Copyright © 2018 Ly Paul H. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy : SKPhysicsBody, GameObject{

    let texture = SKSpriteNode(imageNamed: "enemy")
 
    var hp: Int = 0

    init(hp : Int) {
        texture.physicsBody?.categoryBitMask = 0x1 << 1
        texture.physicsBody = SKPhysicsBody(rectangleOf: texture.size)
        self.hp = hp
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
        
}
