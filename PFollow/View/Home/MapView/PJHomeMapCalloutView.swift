//
//  PJHomeMapCalloutView.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/14.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

class PJHomeMapCalloutView: UIView {

    var title = ""
    var time = ""
    
    private var likeBtn = UIButton()
    private var deleteBtn = UIButton()
    private var commentBtn = UIButton()
    private var shareBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(frame: frame)
        addSubview(stackView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
