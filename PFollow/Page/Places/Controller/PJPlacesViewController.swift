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

    
    var annotationModels: [AnnotationModel]?
    
    private var topView: UIImageView?
    private var animator: UIDynamicAnimator?
    private var titleLabel: UILabel?
    
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.becomeFirstResponder()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resignFirstResponder()
    }
    
    
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
        scene.annotationViews = annotationModels
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
     
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(bottleViewTapped))
        
        
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                           width: view.width, height: 100))
        view.addSubview(titleLabel!)
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 22,
                                             weight: .light)
    }
    
    
    
    // MARK: - Action
    @objc private func backViewTapGestureClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc private func bottleViewTapped() {
        
    }

    
    // MARK: - delegate
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake {
            let model = annotationModels![Int(arc4random_uniform(UInt32(annotationModels!.count)))]
            titleLabel?.text = model.formatterAddress
            PJTapic.succee()
        }
    }
    
}
