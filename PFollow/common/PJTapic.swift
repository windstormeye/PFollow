//
//  PJTapic.swift
//  Bonfire
//
//  Created by pjpjpj on 2018/5/19.
//  Copyright © 2018年 #incloud. All rights reserved.
//

import UIKit

class PJTapic: NSObject {
    
    class func select() {
        let g = UISelectionFeedbackGenerator.init()
        g.selectionChanged()
        g.prepare()
    }
    
    class func succee() {
        let g = UINotificationFeedbackGenerator.init()
        g.notificationOccurred(.success)
        g.prepare()
    }
    
    class func warning() {
        let g = UINotificationFeedbackGenerator.init()
        g.notificationOccurred(.warning)
        g.prepare()
    }
    
    class func error() {
        let g = UINotificationFeedbackGenerator.init()
        g.notificationOccurred(.error)
        g.prepare()
    }
    
    class func tap() {
        UIImpactFeedbackGenerator.init(style: .light).impactOccurred()
    }
    
    class func tipsTap() {
        // if crash, use AudioServicesPlaySystemSound(1519)
        UIImpactFeedbackGenerator.init(style: .heavy).impactOccurred()
    }
    
}
