//
//  PJHomeMapAnnotetionView.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/16.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

@objc protocol PJHomeMapAnnotationViewDelegate {
    @objc optional func homeMapAnnotationView(annotationView: PJHomeMapAnnotationView, removeAnnotaion: MAAnnotation)
    @objc optional func homeMapAnnotationView(annotationView: PJHomeMapAnnotationView, shareAnnotaion: MAAnnotation)
}

class PJHomeMapAnnotationView: MAAnnotationView, PJHomeMapCalloutViewDelegate {

    var title: String {
        willSet(t) {
            willSetTitle(t)
        }
    }
    
    var imageName: String {
        willSet(i) {
            willSetImageName(i)
        }
    }
    
    var temperature: String {
        willSet(t) {
            willSetTemperature(t)
        }
    }
    
    var viewDelegate: PJHomeMapAnnotationViewDelegate?
    
    private var calloutView: PJHomeMapCalloutView?
    private var kCalloutWidth = 180.0
    private var kCalloutHeight = 100.0
    
    
    required init?(coder aDecoder: NSCoder) {
        title = ""
        imageName = ""
        temperature = ""
        super.init(coder: aDecoder)
    }
    
    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        title = ""
        imageName = ""
        temperature = ""
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isSelected == selected {
            return
        }
        if selected {
            if calloutView == nil {
                calloutView = PJHomeMapCalloutView(frame: CGRect(x: 0, y: 0, width: kCalloutWidth, height: kCalloutHeight))
                calloutView?.center = CGPoint(x: bounds.width / 2.0 + calloutOffset.x, y: -((calloutView?.bounds.height)! / 2.0) + calloutOffset.y)
            }
            calloutView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            calloutView?.viewDelegate = self
            calloutView?.y += 20
            calloutView?.alpha = 0
            calloutView?.title = title
            calloutView?.imageName = imageName
            calloutView?.temperature = temperature
            
            UIView.animateKeyframes(withDuration: 0.15, delay: 0, options: .calculationModeCubic, animations: {
                self.calloutView?.alpha = 1.0
                self.calloutView?.y -= 20
                self.calloutView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (finished) in
                PJTapic.tipsTap()
            }
            
            addSubview(calloutView!)
        } else {
            calloutView?.removeFromSuperview()
        }
        super.setSelected(selected, animated: animated)
    }

    
    // 修改响应链
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if calloutView != nil {
            let deletePoint = calloutView?.deleteBtn.convert(point, from: self)
            if (calloutView?.deleteBtn.bounds.contains(deletePoint!))! {
                return calloutView?.deleteBtn
            }
            let sharePoint = calloutView?.shareBtn.convert(point, from: self)
            if (calloutView?.shareBtn.bounds.contains(sharePoint!))! {
                return calloutView?.shareBtn
            }
        }
        return super.hitTest(point, with: event)
    }
    
    
    // MARK: delegate
    func homeMapCalloutRemoveAnnotation(callout: PJHomeMapCalloutView) {
        viewDelegate?.homeMapAnnotationView!(annotationView: self, removeAnnotaion: self.annotation)
    }
    
    
    func homeMapCalloutShareAnnotation(callout: PJHomeMapCalloutView) {
        viewDelegate?.homeMapAnnotationView!(annotationView: self, shareAnnotaion: self.annotation)
    }
    
    
    // MARK: setter and getter
    private func willSetTitle(_ title: String) {
        calloutView?.title = title
    }
    
    
    private func willSetImageName(_ imageName: String) {
        calloutView?.imageName = imageName
    }

    
    private func willSetTemperature(_ t: String) {
        calloutView?.temperature = t
    }
    
}
