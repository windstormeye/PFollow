//
//  AnnotationModel.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/18.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import Foundation


struct AnnotationModel: Codable {
    var weatherString: String
    var createdTimeString: String
    var environmentString: String
    var latitude: String
    var longitude: String
    var tag: String
}
