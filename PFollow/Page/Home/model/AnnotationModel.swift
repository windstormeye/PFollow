//
//  AnnotationModel.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/18.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import Foundation


struct AnnotationModel: Codable {
    // 天气信息
    var weatherString: String
    // 创建时间
    var createdTimeString: String
    // 环境信息
    var environmentString: String
    // 纬度
    var latitude: String
    // 精度
    var longitude: String
    // 每条信息的 ID
    var tag: String
    // 海拔高度
    var altitude: String
    // 步数
    var stepCount: String
    // 城市
    var city: String
    // 格式化地址
    var formatterAddress: String
}
