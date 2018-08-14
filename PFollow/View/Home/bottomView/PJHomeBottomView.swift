//
//  PJHomeBottomView.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/12.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

@objc protocol PJHomeBottomViewDelegate {
    @objc optional func homeBottomViewPlacesBtnClick(view: PJHomeBottomView)
    @objc optional func homeBottomViewTapBtnClick(view: PJHomeBottomView, tapBtn: UIButton)
}

class PJHomeBottomView: UIView {

    var viewDelegate: PJHomeBottomViewDelegate?
    private(set) var stackView: UIStackView?
    
    private var tapBtn = UIButton()
    
    var rotateDegree:CGFloat{
        set {
            self.tapBtn.transform = CGAffineTransform(rotationAngle: newValue * .pi / 180.0)
        }
        get {
            return self.rotateDegree
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        let backView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        addSubview(backView)
        backView.image = UIImage(named: "home_cloud")
        
        stackView = UIStackView(frame: CGRect(x: PJSCREEN_WIDTH * 0.1, y: 30,
                                                  width: PJSCREEN_WIDTH, height: 100))
        stackView?.axis = .horizontal
        stackView?.alignment = .fill
        stackView?.distribution = .fillEqually
        stackView?.spacing = -50
        addSubview(stackView!)
        
        let placesBtn = UIButton()
        placesBtn.layer.shadowColor = UIColor.black.cgColor
        placesBtn.layer.shadowRadius = 5
        placesBtn.layer.shadowOpacity = 0.3
        placesBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        placesBtn.setImage(UIImage(named: "home_places"), for: .normal)
        placesBtn.addTarget(self, action: #selector(placesBtnClick), for: .touchUpInside)
        stackView?.addArrangedSubview(placesBtn)
        
        tapBtn.layer.shadowColor = UIColor.black.cgColor
        tapBtn.layer.shadowRadius = 5
        tapBtn.layer.shadowOpacity = 0.3
        tapBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        tapBtn.setImage(UIImage(named: "home_tap"), for: .normal)
        tapBtn.addTarget(self, action: #selector(tapBtnClick(sender:)), for: .touchUpInside)
        stackView?.addArrangedSubview(tapBtn)
        
        let friendBtn = UIButton()
        friendBtn.layer.shadowColor = UIColor.black.cgColor
        friendBtn.layer.shadowRadius = 5
        friendBtn.layer.shadowOpacity = 0.3
        friendBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        friendBtn.setImage(UIImage(named: "home_friend"), for: .normal)
        friendBtn.addTarget(self, action: #selector(friendBtnClick), for: .touchUpInside)
        stackView?.addArrangedSubview(friendBtn)
    }
    
    @objc private func tapBtnClick(sender: UIButton) {
        print("tap")
        viewDelegate?.homeBottomViewTapBtnClick!(view: self, tapBtn: sender)
    }
    
    @objc private func placesBtnClick() {
        print("places")
        viewDelegate?.homeBottomViewPlacesBtnClick!(view: self)
    }
    
    @objc private func friendBtnClick() {
        print("friend")
    }

}
