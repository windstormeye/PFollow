//
//  PJPlacesViewController.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/12.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

class PJPlacesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func initView() {
        view.backgroundColor = PJRGB(r: 31, g: 31, b: 31)
        
        let backView = UIImageView(frame: CGRect(x: -PJSCREEN_WIDTH * 0.1, y: -60, width: PJSCREEN_WIDTH * 1.2, height: 160))
        let tap = UITapGestureRecognizer(target: self, action: #selector(backViewTapGestureClick))
        backView.addGestureRecognizer(tap)
        tap.numberOfTouchesRequired = 1
        backView.isUserInteractionEnabled = true
        view.addSubview(backView)
        backView.image = UIImage(named: "home_cloud")
    }
    
    
    @objc private func backViewTapGestureClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
