//
//  Player.swift
//  Advance War
//
//  Created by Ly Paul H. on 4/9/18.
//  Copyright © 2018 Ly Paul H. All rights reserved.
//

import Foundation
import SpriteKit

class Player :SKPhysicsBody, GameObject{
    var hp : Int
    
    let texture = SKSpriteNode(imageNamed: "player")
    
    init(hp : Int) {
        self.hp = hp
        super.init()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
