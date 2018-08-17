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

class PJHomeMapView: UIView, MAMapViewDelegate, AMapSearchDelegate, PJHomeMapAnnotationViewDelegate {

    var viewDelegate: PJMapViewDelete?
    private(set) var mapView: MAMapView = MAMapView()
    private var r = MAUserLocationRepresentation()
    private let search = AMapSearchAPI()
    private let req = AMapWeatherSearchRequest()
    private var currentCalloutView: PJHomeMapAnnotationView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        AMapServices.shared().enableHTTPS = true
        
        search?.delegate = self
        req.type = AMapWeatherType.live
        
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
        
        r.image = UIImage(named: "home_map_userlocation")
        r.showsAccuracyRing = false
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
    
    
    // tag == 0 为用户位置蓝点，在添加上 mapView 之前先判断然后不允许进行交互
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        for view in views {
            let v = view as! MAAnnotationView
            if v.tag == 0 {
                v.isUserInteractionEnabled = false
            }
        }
    }
    
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAUserLocation.self) {
            return nil
        }
        
        // 判断如果是 `MAPointAnnotation` 类型则返回自定义大头针
        if annotation.isKind(of: MAPointAnnotation.self) {
            let annotationStyleReuseIndetifier = "annotationStyleReuserIdentifier"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationStyleReuseIndetifier) as! PJHomeMapAnnotationView?
            
            if annotationView == nil {
                annotationView = PJHomeMapAnnotationView(annotation: annotation, reuseIdentifier: annotationStyleReuseIndetifier)
            }
            annotationView?.image = UIImage(named: "home_map_makers_01_b")
            annotationView?.canShowCallout = false
            annotationView?.viewDelegate = self
            annotationView?.tag = mapView.annotations.count + 1
            currentCalloutView = annotationView
            
            let request = AMapReGeocodeSearchRequest()
            request.location = AMapGeoPoint.location(withLatitude: CGFloat(annotation.coordinate.latitude), longitude: CGFloat(annotation.coordinate.longitude))
            request.requireExtension = true
            search?.aMapReGoecodeSearch(request)
            
            // TODO: 最佳做法根据用户当前位置进行判断
            req.city = "杭州"
            search?.aMapWeatherSearch(req)
            
            return annotationView
        }
        
        return nil
    }
    
    
    // MARK:delegate
    
    
    func homeMapAnnotationView(annotationView: PJHomeMapAnnotationView, shareAnnotaion: MAAnnotation) {
        
    }
    
    
    func homeMapAnnotationView(annotationView: PJHomeMapAnnotationView, removeAnnotaion: MAAnnotation) {
        UIView.animate(withDuration: 0.2, animations: {
            annotationView.y -= 15
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 0.2, animations: {
                    annotationView.y += 20
                }, completion: { (finished) in
                    if finished {
                        UIView.animate(withDuration: 0.25, animations: {
                            annotationView.y -= 5
                        }, completion: { (finished) in
                            if finished {
                                UIView.animate(withDuration: 0.25, animations: {
                                    annotationView.alpha = 0
                                }, completion: { (finished) in
                                    if finished {
                                        self.mapView.removeAnnotation(removeAnnotaion)
                                    }
                                })
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if !updatingLocation {
            viewDelegate?.mapView!(self, rotateDegree: CGFloat(userLocation.heading.trueHeading) - mapView.rotationDegree)
        }
    }
    
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        currentCalloutView?.title = "2020-12-29    来过"
    }
    
    
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        print("4666")
    }
    
    
    func mapView(_ mapView: MAMapView!, didAnnotationViewCalloutTapped view: MAAnnotationView!) {
        print("aaaaaaaa")
    }
    
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode != nil {
            
        }
    }
    
    
    func onWeatherSearchDone(_ request: AMapWeatherSearchRequest!, response: AMapWeatherSearchResponse!) {
        // 天气现象
        currentCalloutView?.imageName = response.lives[0].weather
        // 实时温度
        currentCalloutView?.temperature = response.lives[0].temperature
    }
    
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("Error:\(error)")
    }
    
}
