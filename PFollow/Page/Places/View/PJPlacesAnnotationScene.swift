//
//  PJAnnotationScene.swift
//  PFollow
//
//  Created by PJHubs on 2018/9/5.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

import Schedule


class PJPlacesAnnotationScene: SKScene {

    let motionManager = CMMotionManager() // 加速度计管理器
    
    private var bottleViwSprite: SKSpriteNode?
    private var bottleViwSprites = [SKSpriteNode]()
    

    
    // MARK: - life cycle
    override init(size: CGSize) {
        super.init(size: size)
        
        initView()
        initDate()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func initView() {
        self.backgroundColor = PJRGB(r: 11, g: 11, b: 11)
        
        
        bottleViwSprite = SKSpriteNode(imageNamed: "places_bgView")
        bottleViwSprite?.size = CGSize(width: self.size.width * 0.9, height: self.size.width / 0.656)
        bottleViwSprite?.position = CGPoint(x: self.size.width * 0.11,
                                            y: size.height - 10 - bottleViwSprite!.size.height)
        bottleViwSprite?.anchorPoint = CGPoint(x: 0, y: 0)
        bottleViwSprite?.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: bottleViwSprite!.frame.origin.x * 0.45,
                                                                          y: bottleViwSprite!.size.height * 0.1,
                                                                          width: bottleViwSprite!.size.width * 0.75,
                                                                          height: bottleViwSprite!.size.height - bottleViwSprite!.size.height * 0.3))
        self.addChild(bottleViwSprite!)
        
        
        let leftBox = SKSpriteNode(imageNamed: "places_null")
        leftBox.size = CGSize(width: 50, height: 50)
        leftBox.position = CGPoint(x: bottleViwSprite!.frame.origin.x * 0.3, y: bottleViwSprite!.size.height * 0.8)
        leftBox.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        leftBox.physicsBody?.isDynamic = false
        bottleViwSprite?.addChild(leftBox)
        
        
        let rightBox = SKSpriteNode(imageNamed: "places_null")
        rightBox.size = CGSize(width: 50, height: 50)
        let rightBoxRight = leftBox.frame.origin.x + leftBox.size.width
        rightBox.position = CGPoint(x: rightBoxRight + bottleViwSprite!.size.width * 0.7,
                                    y: bottleViwSprite!.size.height * 0.8)
        rightBox.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        rightBox.physicsBody?.isDynamic = false
        bottleViwSprite?.addChild(rightBox)
        
        for i in 0...400 {
            Schedule.after(Double(0.05 * Double(i)).second).do {
                DispatchQueue.main.async {
                    let annotationSprite = SKSpriteNode(imageNamed: "home_map_makers_02")
                    let randomX = self.bottleViwSprite!.size.width - self.bottleViwSprite!.frame.origin.x * 2 - 40
                    let annotationX = CGFloat(arc4random_uniform(UInt32(randomX))) + self.bottleViwSprite!.frame.origin.x
                    annotationSprite.position = CGPoint(x: annotationX, y: self.bottleViwSprite!.size.height * 0.75)
                    annotationSprite.size = CGSize(width: 12, height: 12)
                    annotationSprite.physicsBody = SKPhysicsBody(circleOfRadius: annotationSprite.size.height / 2)
                    annotationSprite.physicsBody?.usesPreciseCollisionDetection = true
                    let scale = arc4random_uniform(3)
                    annotationSprite.scale(to: CGSize(width: CGFloat(scale) * 12, height: CGFloat(scale) * 12))
                    self.bottleViwSprite?.addChild(annotationSprite)
                    
                    self.bottleViwSprites.append(annotationSprite)
                }
            }
        }
        
        startMonitoringAcceleration()
        
    }
    

    private func initDate() {
        
    }
    
    
    // MARK: - 开启加速度计
    func startMonitoringAcceleration(){
        if motionManager.isAccelerometerAvailable {
            // 感应时间
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                guard let accelerometerData = data else {
                    return
                }
                let acceleration = accelerometerData.acceleration
                
                self.physicsWorld.gravity = CGVector(dx: acceleration.x * 9.8,
                                                     dy: acceleration.y * 9.8)
            }
        }
    }
}
