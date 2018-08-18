//
//  PJHomeMapCalloutView.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/14.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

@objc protocol PJHomeMapCalloutViewDelegate {
    @objc optional func homeMapCalloutRemoveAnnotation(callout: PJHomeMapCalloutView)
    @objc optional func homeMapCalloutShareAnnotation(callout: PJHomeMapCalloutView)
    @objc optional func homeMapCalloutTapped(callout: PJHomeMapCalloutView)
}

class PJHomeMapCalloutView: UIView {
    
    var viewDelegate: PJHomeMapCalloutViewDelegate?
    var model: AnnotationModel? {
        willSet(model) {
            willSetModel(model!)
        }
    }
    
    private(set) var shareBtn       = UIButton()
    private(set) var deleteBtn      = UIButton()
    private var weatherImageView    = UIImageView()
    private var titleLabel          = UILabel()
    private var temperatureLabel    = UILabel()
    private let kArrorHeight        = CGFloat(10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        let tapped = UITapGestureRecognizer.init(target: self, action: #selector(calloutViewTapped))
        self.addGestureRecognizer(tapped)
        
        weatherImageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        addSubview(weatherImageView)
        
        temperatureLabel.textColor = .black
        temperatureLabel.textAlignment = .left
        temperatureLabel.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        temperatureLabel.frame = CGRect(x: 22, y: weatherImageView.y, width: 30, height: 20)
        addSubview(temperatureLabel)
        
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        titleLabel.frame = CGRect(x: 5, y: temperatureLabel.bottom + 10, width: self.width - 10, height: 20)
        addSubview(titleLabel)
        
        let stackView = UIStackView(frame: CGRect(x: 0, y: self.bottom - 45, width: self.width, height: 30))
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
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Action
    @objc private func deleteBtnAction() {
        viewDelegate?.homeMapCalloutRemoveAnnotation!(callout: self)
    }
    
    
    @objc private func shareBtnAction() {
        viewDelegate?.homeMapCalloutShareAnnotation!(callout: self)
    }
    
    
    @objc private func calloutViewTapped() {
        viewDelegate?.homeMapCalloutTapped!(callout: self)
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
    private func willSetModel(_ model: AnnotationModel) {
        titleLabel.text = model.createdTimeString + " 来过"
        weatherImageView.image = UIImage(named: model.weatherString)
        temperatureLabel.text = model.environmentString
        temperatureLabel.sizeToFit()
        temperatureLabel.left = weatherImageView.right + 2
        temperatureLabel.centerY = weatherImageView.centerY + 2
    }
    
}
