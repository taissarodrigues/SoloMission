//
//  GameScene.swift
//  SoloMission
//
//  Created by Taissa Vitoria Rodrigues de Paula on 18/05/24.
//

import SpriteKit
import GameplayKit
    class GameScene: SKScene {
        
        let player = SKSpriteNode(imageNamed: "playerShip")
        let bulletSound = SKAction.playSoundFileNamed("bulletSoundEffect.mp3", waitForCompletion: false)
        
        func random() -> CGFloat {
            return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        }
        func random(min min:CGFloat, max: CGFloat) -> CGFloat {
            return random() * (max - min) + min
        }
        
        
        var gameArea: CGRect
        override init(size: CGSize) {
            
            let maxAspectRatio: CGFloat = 16.0/9.0
            let playableWidth = size.height/maxAspectRatio
            let margin = (size.width - playableWidth) / 2
            gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
            
            super.init(size: size)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func didMove(to view: SKView) {
            let background = SKSpriteNode(imageNamed: "background")
            background.size = self.size
            background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            background.zPosition = 0
            self.addChild(background)
           
            player.setScale(1)
            player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
            player.zPosition = 2
            self.addChild(player)
        }
        
        func fireBullet() {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.setScale(1)
            bullet.position = player.position
            self.addChild(bullet)
            
            let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
            let deleteBullet = SKAction.removeFromParent()
            let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
            bullet.run(bulletSequence)
        }
        func spawEnemy() {
            let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
            let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
            let startPoint = CGPoint(x: randomXEnd, y: self.size.height * 1.2)
            
            let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
            
            let enemy = SKSpriteNode(imageNamed: "enemyShip")
            enemy.setScale(1)
            enemy.position = startPoint
            enemy.zPosition = 2
            self.addChild(enemy) //estudar isso//
            
            let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
            let deleteEnemy = SKAction.removeFromParent()
            let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
            enemy.run(enemySequence)
            
            let dx = endPoint.x - startPoint.x
            let dy = endPoint.y - startPoint.y
            let amountRotate = atan2(dy, dx) // estudar isso
            enemy.zRotation = amountRotate
        }
        
        
        
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            fireBullet()
            spawEnemy()
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let pointOfTouch = touch.location(in: self)
                let previousPointOfTouch = touch.previousLocation(in: self)
                
                let amountDragged = pointOfTouch.x - previousPointOfTouch.x
                
                player.position.x += amountDragged
            }
        }
    }

