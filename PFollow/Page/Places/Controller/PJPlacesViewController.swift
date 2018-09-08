//
//  PJPlacesViewController.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/12.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit
import SpriteKit

class PJPlacesViewController: PJBaseViewController {

    
    var annotationModels: [AnnotationModel]?
    
    private var topView: UIImageView?
    private var animator: UIDynamicAnimator?
    private var titleLabel: UILabel?
    private var skView: SKView?
    private var currentModel: AnnotationModel?
    
    
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
        skView = SKView(frame: CGRect(x: 0, y: topView!.bottom,
                                           width: view.width, height: view.height - topView!.bottom))
        view.addSubview(skView!)
        
        let scene = PJPlacesAnnotationScene(size: skView!.frame.size)
        scene.scaleMode = .aspectFill
        scene.annotationModels = annotationModels
        skView?.presentScene(scene)
        
        skView?.ignoresSiblingOrder = true
//        scnView.showsPhysics = true
//        skView?.showsFPS = true
//        skView?.showsNodeCount = true
        
        
        let skViewButton = UIButton(frame: CGRect(x: skView!.x, y: skView!.y,
                                                  width: skView!.width,
                                                  height: skView!.height))
        skViewButton.addTarget(self,
                               action: #selector(bottleViewTapped),
                               for: .touchUpInside)
        view.addSubview(skViewButton)
    }
    
    
    private func initView() {
        view.backgroundColor = PJRGB(r: 11, g: 11, b: 11)
        headerView?.backgroundColor = .white
        UIApplication.shared.statusBarStyle = .default
        
        topView = UIImageView(frame: CGRect(x: -PJSCREEN_WIDTH * 0.1, y: -80 + PJStatusHeight,
                                            width: PJSCREEN_WIDTH * 1.2, height: 160))
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(backViewTapGestureClick))
        topView?.addGestureRecognizer(tap)
        tap.numberOfTouchesRequired = 1
        topView?.isUserInteractionEnabled = true
        view.addSubview(topView!)
        topView?.image = UIImage(named: "home_cloud")
     
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: -PJStatusHeight,
                                           width: view.width, height: 100))
        if iPhoneX {
            titleLabel?.y = 10
        }
        view.addSubview(titleLabel!)
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
        titleLabel?.text = ""
        titleLabel?.font = UIFont.systemFont(ofSize: 22,
                                             weight: .light)
    }
    
    
    
    // MARK: - Action
    @objc private func backViewTapGestureClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc private func bottleViewTapped() {
        if titleLabel?.text != "" {
            let annotationView = PJHomeMapAnnotationView(annotation: nil,
                                                         reuseIdentifier: nil)
            annotationView?.model = currentModel
            let vc = PJAnnotationDetailsViewController()
            vc.annotationView = annotationView
            vc.isHiddenRightBarButton = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    // MARK: - delegate
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake {
            guard annotationModels?.count != 0 else {
                return
            }
            currentModel = annotationModels![Int(arc4random_uniform(UInt32(annotationModels!.count)))]
            titleLabel?.text = currentModel?.formatterAddress
            PJTapic.succee()
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
