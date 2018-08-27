//
//  PJBaseViewController.swift
//  PFollow
//
//  Created by PJHubs on 2018/8/27.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

class PJBaseViewController: UIViewController {
    
    var headerView: UIView?
    
    var navBarHeigt: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // 自定义了 leftBarButtonItem ，需要
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        initView()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: life cycle
    private func initView() {
        navBarHeigt = navigationController!.navigationBar.height + PJStatusHeight
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width,
                                          height: navBarHeigt!))
        view.addSubview(headerView!)
    }
    
    
    func leftBarButtonItemAction(action: Selector) {
        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        leftButton.setImage(UIImage(named: "nav_back"), for: .normal)
        leftButton.addTarget(self, action: action, for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    
    func rightBarButtonItem(imageName: String, action: Selector) {
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        rightButton.setImage(UIImage(named: imageName), for: .normal)
        rightButton.addTarget(self, action: action, for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}
