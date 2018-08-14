//
//  PJHomeMapView.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/12.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

@objc protocol PJMapViewDelete {
    @objc optional func mapView(_ mapView: PJHomeMapView, rotateDegree: CGFloat)
}

class PJHomeMapView: UIView, MAMapViewDelegate {

    var viewDelegate: PJMapViewDelete?
    
    private(set) var mapView: MAMapView = MAMapView()
    private var r = MAUserLocationRepresentation()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        AMapServices.shared().enableHTTPS = true
        
        mapView.frame = frame
        mapView.delegate = self
        // 设置比例尺原点位置
        mapView.scaleOrigin = CGPoint(x: 10, y: 30)
        // 设置罗盘原点位置
        mapView.compassOrigin = CGPoint(x: PJSCREEN_WIDTH - 50, y: 30)
        // 开启地图自定义样式
        mapView.customMapStyleEnabled = true;
        // 显示显示用户位置
        mapView.showsUserLocation = true
        // 用户模式跟踪
        mapView.userTrackingMode = .follow
        
        // TODO: 这块有问题，没法进行用户方向的确定
        r.showsHeadingIndicator = true
        r.showsAccuracyRing = true
        mapView.update(r)
        
        var path = Bundle.main.bundlePath
        path.append("/mapView.data")
        let jsonData = NSData.init(contentsOfFile: path)
        mapView.setCustomMapStyleWithWebData(jsonData as Data?)
        
        addSubview(mapView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        // 判断如果是 `MAPointAnnotation` 类型则返回自定义大头针
        if annotation.isKind(of: MAPointAnnotation.self) {
            let annotationStyleReuseIndetifier = "annotationStyleReuserIdentifier"
            
            var annotationView: MAAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: annotationStyleReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: annotationStyleReuseIndetifier)
            }
            annotationView.image = UIImage(named: "home_map_makers_01")
            annotationView.canShowCallout = true
            return annotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if !updatingLocation {
            viewDelegate?.mapView!(self, rotateDegree: CGFloat(userLocation.heading.trueHeading) - mapView.rotationDegree)
        }
    }
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        print("2333")
    }
    
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        print("4666")
    }
    
    func mapView(_ mapView: MAMapView!, didAnnotationViewCalloutTapped view: MAAnnotationView!) {
        print("aaaaaaaa")
    }
    
}
