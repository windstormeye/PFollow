//
//  PJHomeMapCalloutView.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/14.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

class PJHomeMapCalloutView: UIView {

    // 地理位置
    var title: String {
        willSet(t) {
            willSetTitle(t)
        }
    }
    
    private var likeBtn = UIButton()
    private var commentBtn = UIButton()
    private var shareBtn = UIButton()
    private var deleteBtn = UIButton()
    private var titleLabel = UILabel()
    
    private let kArrorHeight = CGFloat(10)
    
    override init(frame: CGRect) {
        title = ""
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.frame = CGRect(x: 0, y: 10, width: self.width, height: 20)
        addSubview(titleLabel)
        
        let stackView = UIStackView(frame: CGRect(x: 0, y: 35, width: self.width, height: self.height - 45))
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        deleteBtn.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        deleteBtn.setImage(UIImage(named: "callout_delete"), for: .normal)
        stackView.addArrangedSubview(deleteBtn)
        
        shareBtn.addTarget(self, action: #selector(shareBtnAction), for: .touchUpInside)
        shareBtn.setImage(UIImage(named: "callout_share"), for: .normal)
        stackView.addArrangedSubview(shareBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = ""
        super.init(coder: aDecoder)
    }
    
    // MARK: Action
    @objc private func deleteBtnAction() {
        print("delelte")
    }
    
    @objc private func shareBtnAction() {
        print("share")
    }
    
    override func draw(_ rect: CGRect) {
        if let aContext = UIGraphicsGetCurrentContext() {
            draw(in: aContext)
        }
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
    func draw(in context: CGContext) {
        context.setLineWidth(2.0)
        context.setFillColor(UIColor.white.cgColor)
        getDrawPath(context)
        context.fillPath()
    }
    
    func getDrawPath(_ context: CGContext?) {
        let rrect: CGRect = bounds
        let radius: CGFloat = 6.0
        let minx = rrect.minX
        let midx = rrect.midX
        let maxx = rrect.maxX
        let miny = rrect.minY
        let maxy: CGFloat = rrect.maxY - kArrorHeight
        context?.move(to: CGPoint(x: midx + kArrorHeight, y: maxy))
        context?.addLine(to: CGPoint(x: midx, y: maxy + kArrorHeight))
        context?.addLine(to: CGPoint(x: midx - kArrorHeight, y: maxy))
        context?.addArc(tangent1End: CGPoint(x: minx, y: maxy), tangent2End: CGPoint(x: minx, y: miny), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: minx, y: minx), tangent2End: CGPoint(x: maxx, y: miny), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: maxx, y: miny), tangent2End: CGPoint(x: maxx, y: maxx), radius: radius)
        context?.addArc(tangent1End: CGPoint(x: maxx, y: maxy), tangent2End: CGPoint(x: midx, y: maxy), radius: radius)
        context?.closePath()
    }
    
    // MARK: setter and getter
    private func willSetTitle(_ title: String) {
        titleLabel.text = title
    }
    
}
