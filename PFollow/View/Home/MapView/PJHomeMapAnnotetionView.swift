//
//  PJHomeMapAnnotetionView.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/16.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

class PJHomeMapAnnotetionView: MAAnnotationView {

    var title: String {
        willSet(t) {
            calloutView?.title = t
        }
    }
    
    private var calloutView: PJHomeMapCalloutView?
    private var kCalloutWidth = 150.0
    private var kCalloutHeight = 85.0
    
    
    required init?(coder aDecoder: NSCoder) {
        title = ""
        super.init(coder: aDecoder)
    }
    
    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        title = ""
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
            calloutView?.y += 20
            calloutView?.alpha = 0
            
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

}
