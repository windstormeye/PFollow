//
//  PJAnnotationDetailsViewController.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/19.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

class PJAnnotationDetailsViewController: UIViewController {

    var annotationModel: AnnotationModel? {
        willSet(m) {
            willSetModel(m!)
        }
    }
    
    private var environmentLabel = UILabel()
    private var healthLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PJRGB(r: 31, g: 31, b: 31)
        
        environmentLabel.frame = CGRect(x: 0, y: 80, width: view.width, height: 20)
        environmentLabel.textColor = .white
        environmentLabel.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(environmentLabel)
        
        healthLabel.frame = CGRect(x: 0, y: 120, width: view.width, height: 20)
        healthLabel.textColor = .white
        healthLabel.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(healthLabel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func willSetModel(_ model: AnnotationModel) {
        environmentLabel.text = model.environmentString
        healthLabel.text = "海拔：" + model.altitude + " 步数：" + model.stepCount
    }

}
