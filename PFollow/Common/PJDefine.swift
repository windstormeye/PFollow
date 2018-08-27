//
//  PJDefine.swift
//  DiDiData
//
//  Created by PJ on 2018/4/24.
//  Copyright © 2018年 Didi.Inc. All rights reserved.
//

import UIKit
import Foundation


// 屏幕宽高
let PJSCREEN_HEIGHT = CGFloat(UIScreen.main.bounds.height)
let PJSCREEN_WIDTH = CGFloat(UIScreen.main.bounds.width)
let PJTABBAR_HEIGHT = CGFloat(48)
let PJStatusHeight = UIApplication.shared.statusBarFrame.size.height

// 位置相关
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


// 计算字符串长度
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


// 颜色相关
func PJRGB(r: CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}


// 设备相关
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

// 通知
let PJNotificationName_changeLanguage = "PJNotificationNameChangeLanguage"
let PJNotificationName_appOut = "PJNotificationNameAppOut"
let PJNotificationName_network = "kONEONENetworkStatusChange"


