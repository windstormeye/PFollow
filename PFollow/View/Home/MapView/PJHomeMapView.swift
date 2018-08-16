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

class PJHomeMapView: UIView, MAMapViewDelegate, AMapSearchDelegate {

    var viewDelegate: PJMapViewDelete?
    
    private(set) var mapView: MAMapView = MAMapView()
    private var r = MAUserLocationRepresentation()
    private let search = AMapSearchAPI()
    private var currentCalloutView: PJHomeMapAnnotetionView?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        AMapServices.shared().enableHTTPS = true
        
        search?.delegate = self
        
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
        
        if annotation.isKind(of: MAUserLocation.self) {
            return nil
        }
        
        // 判断如果是 `MAPointAnnotation` 类型则返回自定义大头针
        if annotation.isKind(of: MAPointAnnotation.self) {
            let annotationStyleReuseIndetifier = "annotationStyleReuserIdentifier"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationStyleReuseIndetifier) as! PJHomeMapAnnotetionView?
            
            if annotationView == nil {
                annotationView = PJHomeMapAnnotetionView(annotation: annotation, reuseIdentifier: annotationStyleReuseIndetifier)
            }
            annotationView?.image = UIImage(named: "home_map_makers_01")
            annotationView?.canShowCallout = false
            annotationView?.tag = mapView.annotations.count + 1
            currentCalloutView = annotationView
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
        // 这还是有问题
        if view.tag == 0 {
            return
        }
        let request = AMapReGeocodeSearchRequest()
        let coordinate = view.annotation.coordinate
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        request.requireExtension = true
        search?.aMapReGoecodeSearch(request)
    }
    
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        print("4666")
    }
    
    func mapView(_ mapView: MAMapView!, didAnnotationViewCalloutTapped view: MAAnnotationView!) {
        print("aaaaaaaa")
    }
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode != nil {
            currentCalloutView?.title = response.regeocode.formattedAddress as String
        }
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("Error:\(error)")
    }
    
}
