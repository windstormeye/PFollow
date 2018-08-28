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
    @objc optional func homeMapAnnotationViewTappedView(calloutView: PJHomeMapCalloutView, annotationView: PJHomeMapAnnotationView)
}

class PJHomeMapAnnotationView: MAAnnotationView, PJHomeMapCalloutViewDelegate, CAAnimationDelegate {
    
    var viewDelegate: PJHomeMapAnnotationViewDelegate?
    var model: AnnotationModel?
    
    private var calloutView: PJHomeMapCalloutView?
    private var kCalloutWidth = 180.0
    private var kCalloutHeight = 100.0
    
    
    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        model = nil
        super.init(coder: aDecoder)
    }
    
    
    // MARK: override
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
            calloutView?.model = model
            
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
            let calloutPoint = calloutView?.convert(point, from: self)
            if (calloutView?.bounds.contains(calloutPoint!))! {
                return calloutView
            }
        }
        return super.hitTest(point, with: event)
    }

    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        // 防止删除大头针的时候调用该方法，传入 nil
        if newSuperview == nil {
            return
        }
        
        if(newSuperview?.bounds.contains(self.center))! {
            let growAnimation = CABasicAnimation.init(keyPath: "transform.scale")
            growAnimation.delegate = self
            growAnimation.duration = 0.25;
            growAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
            growAnimation.fromValue = 0
            growAnimation.toValue = 1.0
            
            self.layer.add(growAnimation, forKey: "growAnimation")
        }
    }
    
    
    // MARK: delegate
    func homeMapCalloutRemoveAnnotation(callout: PJHomeMapCalloutView) {
        viewDelegate?.homeMapAnnotationView!(annotationView: self, removeAnnotaion: self.annotation)
    }
    
    
    func homeMapCalloutShareAnnotation(callout: PJHomeMapCalloutView) {
        viewDelegate?.homeMapAnnotationView!(annotationView: self, shareAnnotaion: self.annotation)
    }
    
    
    func homeMapCalloutTapped(callout: PJHomeMapCalloutView) {
        viewDelegate?.homeMapAnnotationViewTappedView!(calloutView: callout, annotationView: self)
    }
    
}
