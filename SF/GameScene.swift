//
//  GameScene.swift
//  SF
//
//  Created by admin1 on 08.10.2020.
//  Copyright © 2020 Marsik design. All rights reserved.
//

import SpriteKit
import GameplayKit
    
class GameScene: SKScene, SKPhysicsContactDelegate {
        var Space: SKSpriteNode!
        override func didMove(to view: SKView) {
            
            physicsWorld.contactDelegate = self
            physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.8)
        
            //background
            
            let BackGround = SKSpriteNode(imageNamed: "BackGround")
            BackGround.size = CGSize(width: UIScreen.main.bounds.width * 3.5, height: UIScreen.main.bounds.width * 3.5)
            addChild(BackGround)
            
            // space ship
            Space = SKSpriteNode (imageNamed: "Space")
            Space.physicsBody = SKPhysicsBody(texture: Space.texture!, size: Space.size)
            Space.physicsBody?.isDynamic = false
            
            addChild(Space)
            
            func distanceCalc(a: CGPoint, b: CGPoint) -> CGFloat {
                return sqrt((b.x - a.x) + (b.y) + (b.y - a.y)*(b.y - a.y))
            }
            
            //add space ship speed
            func timeToTravelDistance(distance: CGFloat, speed: CGFloat) -> TimeInterval {
                let time = distance / speed
                return TimeInterval(time)
            }
            
            let StoneCreate = SKAction.run {
                let Stone = self.createStone()
                self.addChild(Stone)
            }
            let StoneCreationDelay = SKAction.wait(forDuration: 1.0, withRange: 0.5)
            let StoneSequenceAction = SKAction.sequence([StoneCreate, StoneCreationDelay])
            _ = SKAction.repeatForever(StoneSequenceAction)
            
            run(StoneSequenceAction)
        }
        
        //move by finger touch
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            if let touch = touches.first {
                
                let touchLocation = touch.location(in: self)
                print(touchLocation)
                
                let moveAction = SKAction.move(to: touchLocation, duration: 1)
                Space.run(moveAction)
            }
            
        }
        
        //add stones
    func createStone() -> SKSpriteNode {
           let Stone = SKSpriteNode(imageNamed:"Stone");

        Stone.position.x = CGFloat(frame.size.height)
        Stone.position.y = frame.size.height / 2
        
        Stone.physicsBody = SKPhysicsBody(texture: Stone.texture!, size: Stone.size)
        Stone.name = "Stone"
        
       
           return Stone
    }
        override func update( _ currentTime: TimeInterval) {
            let Stone = createStone()
            addChild(Stone)
        }
        
        //add physics for stones to make less nodes
        override func didSimulatePhysics() {
            enumerateChildNodes(withName: "Stone") { (Stone, stop) in
                let hight = UIScreen.main.bounds.height
                if Stone.position.y < -hight {
                    Stone.removeFromParent()
                }
                
            }
        }
    }

