//
//  PJHomeBottomView.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/12.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

protocol PJHomeBottomViewDelegate: class {
    func homeBottomViewPlacesBtnClick(view: PJHomeBottomView)
    func homeBottomViewTapBtnClick(view: PJHomeBottomView, tapBtn: UIButton)
}
extension PJHomeBottomViewDelegate {
    func homeBottomViewPlacesBtnClick(view: PJHomeBottomView) {}
    func homeBottomViewTapBtnClick(view: PJHomeBottomView, tapBtn: UIButton) {}
}

class PJHomeBottomView: UIView {

    weak var viewDelegate: PJHomeBottomViewDelegate?
    var rotateDegree:CGFloat{
        set {
            self.compassImageView.transform = CGAffineTransform(rotationAngle: newValue * .pi / 180.0)
        }
        get {
            return self.rotateDegree
        }
    }
    
    var isRequest: Bool {
        willSet(b) {
            willSetIsRequest(b)
        }
    }
    
    private(set) var tapBtn = UIButton()
    private(set) var addAnnotationOKImageView = UIImageView()
    
    private var compassImageView = UIImageView()
    private var indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // MARK: life cycle
    override init(frame: CGRect) {
        isRequest = false
        super.init(frame: frame)
        initView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        isRequest = false
        super.init(coder: aDecoder)
    }
    
    
    private func initView() {
        let backView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        addSubview(backView)
        backView.isUserInteractionEnabled = true
        backView.image = UIImage(named: "home_cloud")
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(placesBtnClick))
        backView.addGestureRecognizer(tapped)
        
        tapBtn.width = 70
        tapBtn.height = 70
        // 0.1 为 cloud 的放大偏移量
        tapBtn.centerX = self.centerX + PJSCREEN_WIDTH * 0.1
        tapBtn.y = 40
        tapBtn.layer.shadowColor = UIColor.black.cgColor
        tapBtn.layer.shadowRadius = 5
        tapBtn.layer.shadowOpacity = 0.3
        tapBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        tapBtn.setImage(UIImage(named: "home_tap"), for: .normal)
        tapBtn.addTarget(self, action: #selector(tapBtnClick(sender:)), for: .touchUpInside)
        addSubview(tapBtn)
        
        compassImageView.width = 30
        compassImageView.height = 30
        compassImageView.center = tapBtn.center
        compassImageView.image = UIImage(named: "home_bottom_compass")
        addSubview(compassImageView)
        
        addAnnotationOKImageView.width = 30
        addAnnotationOKImageView.height = 30
        addAnnotationOKImageView.center = tapBtn.center
        addAnnotationOKImageView.image = UIImage(named: "home_tap_ok")
        addSubview(addAnnotationOKImageView)
        addAnnotationOKImageView.isHidden = true
        addAnnotationOKImageView.alpha = 0
        
        indicator.width = 30
        indicator.height = 30
        indicator.center = tapBtn.center
        addSubview(indicator)
        indicator.isHidden = true
    }
    
    
    // MARK: Action
    @objc private func tapBtnClick(sender: UIButton) {
        print("tap")
        viewDelegate?.homeBottomViewTapBtnClick(view: self, tapBtn: sender)
    }
    
    @objc private func placesBtnClick() {
        print("places")
        viewDelegate?.homeBottomViewPlacesBtnClick(view: self)
    }
    
    @objc private func friendBtnClick() {
        print("friend")
    }
    
    
    private func willSetIsRequest(_ b: Bool) {
        if b {
            tapBtn.isEnabled = false
            compassImageView.isHidden = true
            indicator.isHidden = false
            indicator.startAnimating()
        } else {
            indicator.isHidden = true
            indicator.stopAnimating()
            addAnnotationOKImageView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                self.addAnnotationOKImageView.alpha = 1.0
                self.addAnnotationOKImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                PJTapic.tap()
            }) { (finished) in
                self.addAnnotationOKImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                PJTapic.tipsTap()
                
                UIView.animate(withDuration: 0.25, delay: 0.5, options: .curveEaseIn    , animations: {
                    self.addAnnotationOKImageView.alpha = 0
                }, completion: { (finished) in
                    if finished {
                        self.addAnnotationOKImageView.isHidden = true
                        self.compassImageView.isHidden = false
                        self.tapBtn.isEnabled = true
                    }
                })
            }
        }
    }

}
