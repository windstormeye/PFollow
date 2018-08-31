 //
//  PJHomeMapView.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/12.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit
import CoreMotion

 protocol PJMapViewDelete: class {
    func mapView(mapView: PJHomeMapView,
                 rotateDegree: CGFloat)
    func mapView(mapView: PJHomeMapView,
                 isRequested: Bool)
    func mapView(mapView: PJHomeMapView,
                 didLongPressCoordinate: CLLocationCoordinate2D)
    func mapViewInitComplate(_ mapView: PJHomeMapView)
    func mapViewTappedCalloutView(_ mapView: PJHomeMapView,
                                  annotationView: PJHomeMapAnnotationView)
}
extension PJMapViewDelete {
    func mapView(mapView: PJHomeMapView,
                 rotateDegree: CGFloat) {}
    func mapView(mapView: PJHomeMapView,
                 isRequested: Bool) {}
    func mapView(mapView: PJHomeMapView,
                 didLongPressCoordinate: CLLocationCoordinate2D) {}
    func mapViewInitComplate(_ mapView: PJHomeMapView) {}
    func mapViewTappedCalloutView(_ mapView: PJHomeMapView,
                                  annotationView: PJHomeMapAnnotationView) {}
}

class PJHomeMapView: UIView, MAMapViewDelegate, AMapSearchDelegate, PJHomeMapAnnotationViewDelegate {

    static let PJNotificationName_annotation = Notification.Name("PJNotificationName_annotation")
    
    weak var viewDelegate: PJMapViewDelete?
    var models = [AnnotationModel]()
    
    // 是否从 CoreData 中读取数据
    var isCache = false
    // 是否为新建标记点
    var isNewAnnotation = true
    
    private var isBigZoom = false
    private var isSmallZoom = false
    private var notificationRecoder = 0
    private var currentCacheAnnotationIndex = 0
    private var mapViewAnnotationImageName = "home_map_makers_01_b"
    
    private var currentAnnotationModel: AnnotationModel?
    private var currentAnnotation: MAAnnotation?
    private var currentAnnotationView: PJHomeMapAnnotationView?
    
    private(set) var mapView: MAMapView = MAMapView()
    private var r = MAUserLocationRepresentation()
    private var pedometer = CMPedometer()
    private let search = AMapSearchAPI()
    private let req = AMapWeatherSearchRequest()
    private var finalModelDict = [String: String]()
    private var annotationViews = [PJHomeMapAnnotationView]()
    
    
    // MARK: life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(messageQueueNotification(notify:)),
                                               name: PJHomeMapView.PJNotificationName_annotation,
                                               object: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    fileprivate func initView() {
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
        addSubview(mapView)
        
        r.image = UIImage(named: "home_map_userlocation")
        r.showsAccuracyRing = false
        mapView.update(r)
        
        var path = Bundle.main.bundlePath
        path.append("/mapView.data")
        let jsonData = NSData.init(contentsOfFile: path)
        mapView.setCustomMapStyleWithWebData(jsonData as Data?)
    }
    
    
    // MARK: notification
    @objc private func messageQueueNotification(notify: Notification) {
        var params = notify.userInfo as! [String: String]
        if params["notifi_name"] == "city" {
            notificationRecoder += 1
            params.removeValue(forKey: "notifi_name")
            finalModelDict.merge(params,
                                 uniquingKeysWith: { $1 })
        }
        
        if params["notifi_name"] == "weather" {
            params.removeValue(forKey: "notifi_name")
            notificationRecoder += 1
            finalModelDict.merge(params,
                                 uniquingKeysWith: { $1 })
        }
        
        if notificationRecoder == 2 {
            notificationRecoder = 0
            getPedonmeterData(json: finalModelDict)
        }
        
    }
    
    private func getPedonmeterData(json: [String: String]) {
        pedometer = CMPedometer()
        if CMPedometer.isStepCountingAvailable(){
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.year, .month, .day],
                                                     from: now)
            let startDate = calendar.date(from: components)
            pedometer.queryPedometerData(from: startDate!, to: Date(), withHandler: { (data, error) in
                if error != nil{
                    print("/(error?.localizedDescription)")
                }else{
                    if data != nil {
                        var json = json
                        json["stepCount"] = String(Int(truncating: (data?.numberOfSteps)!))
                        if let json = try? JSONSerialization.data(withJSONObject: json,
                                                                  options: []) {
                            if let annotationModel = try? JSONDecoder().decode(AnnotationModel.self,
                                                                               from: json) {
                                DispatchQueue.main.async {
                                    self.currentAnnotationView?.model = annotationModel
                                    self.annotationViews.append(self.currentAnnotationView!)
                                    
                                    self.viewDelegate?.mapView(mapView: self, isRequested: PJCoreDataHelper.shared.addAnnotation(model: annotationModel))
                                }
                            }
                        }
                    }
                }
            })
        }
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
    
    
    func mapView(_ mapView: MAMapView!,
                 viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        // 若为用户标签则 nil
        if annotation.isKind(of: MAUserLocation.self) {
            return nil
        }
        
        // 判断如果是 `MAPointAnnotation` 类型则返回自定义大头针
        if annotation.isKind(of: MAPointAnnotation.self) {
            let annotationStyleReuseIndetifier = "annotationStyleReuserIdentifier"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationStyleReuseIndetifier) as! PJHomeMapAnnotationView?
            
            if annotationView == nil {
                annotationView = PJHomeMapAnnotationView(annotation: annotation,
                                                         reuseIdentifier: annotationStyleReuseIndetifier)
            }
            annotationView?.image = UIImage(named: mapViewAnnotationImageName)
            annotationView?.canShowCallout = false
            annotationView?.viewDelegate = self
            // 该 tag 只是用于跟 userLocal 标记分开，不能唯一标识一个大头针
            annotationView?.tag = -2333
            
            currentAnnotation = annotation
            currentAnnotationView = annotationView
            
            if isCache && !isNewAnnotation {
                for model in models {
                    if Double(model.latitude) == annotation.coordinate.latitude &&
                        Double(model.longitude) == annotation.coordinate.longitude {
                        annotationView?.model = model
                        annotationViews.append(annotationView!)
                        break
                    }
                }
                return annotationView
            }
            
            let request = AMapReGeocodeSearchRequest()
            request.location = AMapGeoPoint.location(withLatitude: CGFloat(annotation.coordinate.latitude),
                                                     longitude: CGFloat(annotation.coordinate.longitude))
            request.requireExtension = true
            search?.aMapReGoecodeSearch(request)
            
            // 添加完新的标记点后，设置为 false
            isNewAnnotation = false
            
            return annotationView
        }
        
        return nil
    }
    
    
    // MARK:delegate
    func homeMapAnnotationView(annotationView: PJHomeMapAnnotationView,
                               shareAnnotaion: MAAnnotation) {
        
    }
    
    
    func homeMapAnnotationView(annotationView: PJHomeMapAnnotationView,
                               removeAnnotaion: MAAnnotation) {
        PJCoreDataHelper.shared.deleteAnnotation(model: annotationView.model!)
        
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
                                        var index = 0
                                        for annotation in self.annotationViews {
                                            if Double(annotation.model!.latitude) == removeAnnotaion.coordinate.latitude &&
                                                Double(annotation.model!.longitude) == removeAnnotaion.coordinate.longitude {
                                                self.annotationViews.remove(at: index)
                                                // 删除完毕要退出。😂
                                                return
                                            }
                                            index += 1
                                        }
                                    }
                                })
                            }
                        })
                    }
                })
            }
        }
    }
    
    
    func homeMapAnnotationViewTappedView(calloutView: PJHomeMapCalloutView, annotationView: PJHomeMapAnnotationView) {
        viewDelegate?.mapViewTappedCalloutView(self, annotationView: annotationView)
    }
    
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if !updatingLocation {
            viewDelegate?.mapView(mapView: self,
                                  rotateDegree: CGFloat(userLocation.heading.trueHeading) - mapView.rotationDegree)
        }
    }
    
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        if response.regeocode != nil {
            req.city = response.regeocode.addressComponent.city
            search?.aMapWeatherSearch(req)
            
            let params: [String: String] = [
                "notifi_name": "city",
                
                "city": response.regeocode.addressComponent.city,
                "formatterAddress": response.regeocode.formattedAddress
            ]
            NotificationCenter.default.post(name: PJHomeMapView.PJNotificationName_annotation, object: nil, userInfo: params)
            
            print(response.regeocode.addressComponent.city)
            print(response.regeocode.addressComponent.citycode)
        }
    }
    
    
    func onWeatherSearchDone(_ request: AMapWeatherSearchRequest!, response: AMapWeatherSearchResponse!) {
        let environmentString = response.lives[0].temperature + "° " + response.lives[0].windDirection + "风" + response.lives[0].windPower + "级 " + response.lives[0].humidity + "%rh"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let params: [String: String] = [
            "notifi_name": "weather",
            
            "createdTimeString": timeFormatter.string(from: Date()) as String,
            "weatherString": response.lives[0].weather,
            "environmentString": environmentString,
            "latitude": String(Double((currentAnnotation?.coordinate.latitude)!)),
            "longitude": String(Double((currentAnnotation?.coordinate.longitude)!)),
            "altitude": String(Int(mapView.userLocation.location.altitude))
            ]
        NotificationCenter.default.post(name: PJHomeMapView.PJNotificationName_annotation, object: nil, userInfo: params)
    }
    
    
    func mapView(_ mapView: MAMapView!, mapDidZoomByUser wasUserAction: Bool) {
        
        func changeAnnotation() {
            let annotationSet = mapView.annotations(in: mapView.visibleMapRect).filter { (item) in
                !(item is MAUserLocation) } as! Set<MAPointAnnotation>
            
            mapView.removeAnnotations(Array(annotationSet))
            
            for annotation in annotationSet {
                let pointAnnotation = MAPointAnnotation()
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                mapView.addAnnotation(pointAnnotation)
            }
        }
        
        if mapView.zoomLevel <= 12.8 {
            if isSmallZoom == false {
                mapViewAnnotationImageName = "home_map_makers_02"
                isSmallZoom = true
                isBigZoom = false
                
                changeAnnotation()
            }
        } else {
            if isBigZoom == false {
                mapViewAnnotationImageName = "home_map_makers_01_b"
                isBigZoom = true
                isSmallZoom = false
                
                changeAnnotation()
            }
        }
    }
    
    
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        guard annotationViews.count != 0 else {
            return
        }
        
        let annotationSet = mapView.annotations(in: mapView.visibleMapRect).filter { (item) in
            !(item is MAUserLocation) } as! Set<MAPointAnnotation>
        
        for annotation in Array(annotationSet) {
            for annotationView in annotationViews {
                if annotation.coordinate.latitude == Double(annotationView.model!.latitude) &&
                    annotation.coordinate.longitude == Double(annotationView.model!.longitude) {
                    if mapView.zoomLevel < 12.8 {
                        if annotationView.image == UIImage(named: "home_map_makers_01_b") {
                            annotationView.image = UIImage(named: "home_map_makers_02")
                        }
                    } else {
                        if annotationView.image == UIImage(named: "home_map_makers_02") {
                            annotationView.image = UIImage(named: "home_map_makers_01_b")
                        }
                    }
                }
            }
        }
    }
    
    
    func mapView(_ mapView: MAMapView!, didLongPressedAt coordinate: CLLocationCoordinate2D) {
        viewDelegate?.mapView(mapView: self, didLongPressCoordinate: coordinate)
    }
    
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("Error:\(error)")
    }
    
    
    func mapInitComplete(_ mapView: MAMapView!) {
        viewDelegate?.mapViewInitComplate(self)
    }
    
    
}
