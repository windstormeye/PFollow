//
//  PJHomeViewController.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/12.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

class PJHomeViewController: UIViewController, PJHomeBottomViewDelegate, PJMapViewDelete {

    var mapView: PJHomeMapView?
    var bottomView: PJHomeBottomView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 视图载入完成后，设置地图缩放等级
        mapView?.mapView.setZoomLevel(15, animated: true)
        
        if bottomView?.tapBtn.alpha == 0 {
            UIView.animate(withDuration: 0.25) {
                self.bottomView?.tapBtn.alpha = 1
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: life cycle
    private func initView() {
        mapView = PJHomeMapView.init(frame: CGRect(x: 0, y: 0, width: PJSCREEN_WIDTH, height: PJSCREEN_HEIGHT))
        mapView?.viewDelegate = self
        view.addSubview(mapView!)
        
        bottomView = PJHomeBottomView.init(frame: CGRect(x: -PJSCREEN_WIDTH * 0.1, y: PJSCREEN_HEIGHT - 120, width: PJSCREEN_WIDTH * 1.2, height: 160))
        bottomView?.viewDelegate = self
        view.addSubview(bottomView!)
    }
    
    
    // MARK: delegate
    func homeBottomViewPlacesBtnClick(view: PJHomeBottomView) {
        UIView.animate(withDuration: 0.25, animations: {
            self.bottomView?.tapBtn.alpha = 0
        }) { (finished) in
            if finished {
                self.present(PJPlacesViewController(), animated: true, completion: nil)
            }
        }
    }
    
    
    func homeBottomViewTapBtnClick(view: PJHomeBottomView, tapBtn: UIButton) {
        bottomView?.isRequest = true
        UIView.animate(withDuration: 0.15, animations: {
            tapBtn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (finished) in
            if finished {
                UIView.animate(withDuration: 0.15, animations: {
                    tapBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
                }) {(finished) in
                    if finished {
                        let point = self.mapView?.mapView.convert((self.mapView?.mapView.userLocation.location.coordinate)!, toPointTo: self.mapView)
                        print(point as Any)
                        let tempTapImageView = UIImageView(image: UIImage(named: "home_tap"))
                        tempTapImageView.frame.size = CGSize(width: 50, height: 50)
                        tempTapImageView.centerX = view.centerX
                        tempTapImageView.bottom = (self.bottomView?.bottom)!
                        self.view.addSubview(tempTapImageView)
                        UIView.animate(withDuration: 0.25, animations: {
                            tempTapImageView.center = point!
                        }) {(finished) in
                            if finished {
                                UIView.animate(withDuration: 0.5, animations: {
                                    tempTapImageView.alpha = 0
                                }, completion: { (finished) in
                                    if finished {
                                        tempTapImageView.removeFromSuperview()
                                        self.mapView?.isCache = false
                                        
                                        let pointAnnotation = MAPointAnnotation()
                                        pointAnnotation.coordinate = (self.mapView?.mapView.userLocation.location.coordinate)!
                                        self.mapView?.mapView.addAnnotation(pointAnnotation)
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func mapView(_ mapView: PJHomeMapView, rotateDegree: CGFloat) {
        // 调整指南针选择方向角度
        bottomView?.rotateDegree = (rotateDegree - 45)
    }
    
    
    func mapView(_ mapView: PJHomeMapView, isRequested: Bool) {
        // 如果失败要给 HUD 提示
        if isRequested {
            bottomView?.isRequest = !isRequested
        }
    }

    
    func mapViewInitComplate(_ mapView: PJHomeMapView) {
        // 读取 Annotation 缓存
        let caches = PJCoreDataHelper.shared.allAnnotation()
        if caches.count != 0 {
            mapView.models = caches
            mapView.isCache = true
            for annotation in caches {
                let pointAnnotation = MAPointAnnotation()
                pointAnnotation.coordinate = CLLocationCoordinate2D.init(latitude: Double(annotation.latitude)!, longitude: Double(annotation.longitude)!)
                mapView.mapView.addAnnotation(pointAnnotation)
            }
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
