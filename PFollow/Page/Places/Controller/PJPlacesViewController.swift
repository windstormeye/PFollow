//
//  PJPlacesViewController.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/12.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit
import SpriteKit

class PJPlacesViewController: UIViewController {

    
    private var topView: UIImageView?
    
    private var animator: UIDynamicAnimator?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initScene()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    
    private func initScene() {
        let scnView = SKView(frame: CGRect(x: 0, y: topView!.bottom,
                                           width: view.width, height: view.height - topView!.bottom))
        view.addSubview(scnView)
        
        let scene = PJPlacesAnnotationScene(size: scnView.frame.size)
        scene.scaleMode = .aspectFill
        scnView.presentScene(scene)
//        scnView.showsPhysics = true
        scnView.ignoresSiblingOrder = true
        
        scnView.showsFPS = true
        scnView.showsNodeCount = true
    }
    
    
    private func initView() {
        view.backgroundColor = PJRGB(r: 11, g: 11, b: 11)
        
        topView = UIImageView(frame: CGRect(x: -PJSCREEN_WIDTH * 0.1, y: -60,
                                            width: PJSCREEN_WIDTH * 1.2, height: 160))
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(backViewTapGestureClick))
        topView?.addGestureRecognizer(tap)
        tap.numberOfTouchesRequired = 1
        topView?.isUserInteractionEnabled = true
        view.addSubview(topView!)
        topView?.image = UIImage(named: "home_cloud")
        
        
//        bgImageView = UIImageView(frame: CGRect(x: view.width * 0.11, y: topView.bottom + 10, width: view.width * 0.9, height: view.width / 0.656))
//        view.addSubview(bgImageView!)
//        bgImageView?.image = UIImage(named: "places_bgView")
//
//
//        // MARK: 物理
//        animator = UIDynamicAnimator(referenceView: view)
//
//        let gravity = UIGravityBehavior()
//        let collisionBehavior = UICollisionBehavior()
//        collisionBehavior.collisionMode = .everything
//        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
//
//        var index = 0
//        for _ in 0...50 {
//            Schedule.after((0.05 * Double(index)).second).do {
//                DispatchQueue.main.async {
//                    // MARK: UI
//                    let annotation = UIImageView(image: UIImage(named: "home_map_makers_02"))
//                    annotation.width = 12
//                    annotation.height = 12
//                    let randomX = self.bgImageView!.width - self.bgImageView!.left * 2 - 40
//                    annotation.x = CGFloat(arc4random_uniform(UInt32(randomX))) + self.bgImageView!.left + 30
//                    annotation.y = self.bgImageView!.top + 50
//
//                    self.view.addSubview(annotation)
//                    self.view.sendSubview(toBack: annotation)
//
//                    // MARK: 物理
//
//                    collisionBehavior.addItem(annotation)
//
//                    let BottomfloorY = self.bgImageView!.bottom - self.bgImageView!.height * 0.1
//                    let BotoomfloorLetf = self.bgImageView!.left + 20
//                    let BotoomfloorRight = self.bgImageView!.right - 20
//                    collisionBehavior.addBoundary(withIdentifier: "bottomFloor" as NSCopying,
//                                                  from: CGPoint(x: BotoomfloorLetf, y: BottomfloorY),
//                                                  to: CGPoint(x: BotoomfloorRight, y: BottomfloorY))
//
//                    let LeftfloorY = self.bgImageView!.bottom - self.bgImageView!.height * 0.1
//                    let LeftfloorLetf = self.bgImageView!.left
//                    let LeftfloorRight = self.view.width - self.bgImageView!.left
//                    collisionBehavior.addBoundary(withIdentifier: "leftFloor" as NSCopying,
//                                                  from: CGPoint(x: BotoomfloorLetf, y : self.bgImageView!.top + self.bgImageView!.height * 0.2),
//                                                  to: CGPoint(x: BotoomfloorLetf, y: BottomfloorY))
//
//                    self.animator?.addBehavior(collisionBehavior)
//                    gravity.addItem(annotation)
//                }
//
//            }
//            index += 1
//        }
//
//        animator?.addBehavior(gravity)
    }
    
    
    @inline(__always) private func Delay(time: Double, afterBlock: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
                                      execute: {
            afterBlock()
        })
    }
    
    @objc private func backViewTapGestureClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
