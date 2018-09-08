//
//  PJDefine.swift
//  DiDiData
//
//  Created by PJ on 2018/4/24.
//  Copyright © 2018年 Didi.Inc. All rights reserved.
//

import UIKit
import Foundation


// MARK: - 设备
let PJSCREEN_HEIGHT = CGFloat(UIScreen.main.bounds.height)
let PJSCREEN_WIDTH = CGFloat(UIScreen.main.bounds.width)
let PJTABBAR_HEIGHT = CGFloat(48)
let PJStatusHeight = UIApplication.shared.statusBarFrame.size.height

// 不能直接这么写死 34
let PJBottomLinerHeight = iPhoneX ? CGFloat(34) : 0
let iPhoneX = PJSCREEN_HEIGHT == 812

func PJDeviceWithPortrait() -> Bool {
    return UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
}

func PJDevice() -> String {
    let currentScreen = UIScreen.main.currentMode?.size
    if currentScreen == CGSize.init(width: 1125, height: 2436) {
        return "iPhoneX"
    } else {
        return "None"
    }
}

func PJUILength(length: Int) -> CGFloat {
    return PJSCREEN_WIDTH * CGFloat(length) / 375
}


// MARK: - 位置
func x(object: UIView) -> CGFloat {
    return object.frame.origin.x
}
func y(object: UIView) -> CGFloat {
    return object.frame.origin.y
}
func w(object: UIView) -> CGFloat {
    return object.frame.size.width
}
func h(object: UIView) -> CGFloat {
    return object.frame.size.height
}


// MARK: - 字符串
func getStringLength(string: String) -> CGFloat {
    let count = string.count;
    if inputLetterAndSpace(string) {
        return CGFloat(9 * count)
    }
    return CGFloat(16 * count)
}

func inputLetterAndSpace(_ string: String) -> Bool {
    let regex = "[ a-zA-Z]*"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    let inputString = predicate.evaluate(with: string)
    return inputString
}


// MARK: - 颜色
func PJRGB(r: CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}


// MARK: - 视图
func PJInsertRoundingCorners(_ view: UIView) {
    let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8.0, height: 8.0))
    let pathMaskLayer = CAShapeLayer()
    pathMaskLayer.frame = view.bounds
    pathMaskLayer.path = path.cgPath
    view.layer.mask = pathMaskLayer
}

// MARK: - 通知
let PJNotificationName_changeLanguage = "PJNotificationNameChangeLanguage"
let PJNotificationName_appOut = "PJNotificationNameAppOut"
let PJNotificationName_network = "kONEONENetworkStatusChange"
let PJNotificationName_updateCallouView = "PJNotitficationNameUpdateCallout"


