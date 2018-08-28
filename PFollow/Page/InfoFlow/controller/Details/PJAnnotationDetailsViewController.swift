//
//  PJAnnotationDetailsViewController.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/19.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

class PJAnnotationDetailsViewController: PJBaseViewController, UIScrollViewDelegate, UITextViewDelegate {

    var annotationModel: AnnotationModel? {
        willSet(m) {
            willSetModel(m!)
        }
    }
    
    
    private var environmentLabel = UILabel()
    private var healthLabel = UILabel()
    private var locationLabel = UILabel()
    
    private var contentTextView: UITextView?
    private var photoContentView: UIView?
    private var addPhotoButton: UIButton?
    private var contentTextViewTipsLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftBarButtonItemAction(action: #selector(leftBarButtonTapped))
        rightBarButtonItem(imageName: "annotation_details_save", action: #selector(rightButtonTapped))
        view.backgroundColor = PJRGB(r: 31, g: 31, b: 31)
        
        initView()
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: -life cycle
    fileprivate func initView() {
        
        let backScrollView = UIScrollView(frame: CGRect(x: 0, y: headerView!.bottom,
                                                        width: view.width, height: view.height))
        backScrollView.delegate = self
        backScrollView.showsVerticalScrollIndicator = false
        view.addSubview(backScrollView)
        
        
        locationLabel.frame = CGRect(x: 10, y: 0,
                                     width: view.width - 20, height: navBarHeigt!)
        locationLabel.font = UIFont.boldSystemFont(ofSize: 22)
        locationLabel.textColor = .white
        locationLabel.numberOfLines = 2
        backScrollView.addSubview(locationLabel)
        
        
        let envImageView = UIImageView(frame: CGRect(x: 10, y: locationLabel.bottom + 20,
                                                     width:15    , height: 20))
        backScrollView.addSubview(envImageView)
        envImageView.image = UIImage(named: "annotation_details_env")
        
        
        environmentLabel.frame = CGRect(x: 35, y: envImageView.top,
                                        width: view.width - 20, height: 20)
        environmentLabel.textColor = .white
        environmentLabel.font = UIFont.boldSystemFont(ofSize: 15)
        backScrollView.addSubview(environmentLabel)
        
        
        let heaImageView = UIImageView(frame: CGRect(x: 10, y: envImageView.bottom + 10,
                                                     width: 17.5, height: 20))
        backScrollView.addSubview(heaImageView)
        heaImageView.image = UIImage(named: "annotation_details_altitude")
        
        
        healthLabel.frame = CGRect(x: 35, y: heaImageView.top,
                                   width: view.width - 20, height: 20)
        healthLabel.textColor = .white
        healthLabel.font = UIFont.boldSystemFont(ofSize: 15)
        backScrollView.addSubview(healthLabel)
        
        
        contentTextView = UITextView(frame: CGRect(x: 10, y: heaImageView.bottom + 30,
                                                   width: view.width - 20, height: 200))
        backScrollView.addSubview(contentTextView!)
        contentTextView?.delegate = self
        contentTextView?.backgroundColor = PJRGB(r: 50, g: 50, b: 50)
        contentTextView?.tintColor = .white
        contentTextView?.layer.cornerRadius = 8
        contentTextView?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        contentTextView?.textColor = .white
        contentTextView?.layer.masksToBounds = true
        
        
        contentTextViewTipsLabel = UILabel(frame: CGRect(x: 5, y: 10,
                                                         width: contentTextView!.width, height: 20))
        contentTextView?.addSubview(contentTextViewTipsLabel!)
        contentTextViewTipsLabel?.font = contentTextView?.font
        contentTextViewTipsLabel?.textColor = contentTextView?.textColor
        
        
        photoContentView = UIView(frame: CGRect(x: contentTextView!.left, y: contentTextView!.bottom + 20, width: contentTextView!.width, height: 100))
        photoContentView?.backgroundColor = contentTextView?.backgroundColor
        backScrollView.addSubview(photoContentView!)
        backScrollView.layer.cornerRadius = 8
        backScrollView.layer.masksToBounds = true
        
        
        addPhotoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        backScrollView.addSubview(addPhotoButton!)
        addPhotoButton?.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        addPhotoButton?.center = photoContentView!.center
        addPhotoButton?.setTitleColor(.white, for: .normal)
        addPhotoButton?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        addPhotoButton?.setTitle("点击添加照片", for: .normal)
        
        
        
        backScrollView.contentSize = CGSize(width: 0, height: view.height + 1)
    }
    
    
    private func initData() {
        let content = PJCoreDataHelper.shared.annotationContent(model: annotationModel!)
        if content == "" {
            contentTextViewTipsLabel?.isHidden = false
            contentTextViewTipsLabel?.text = "快来填写签到内容吧～"
        } else {
            contentTextViewTipsLabel?.isHidden = true
            contentTextView?.text = content
        }
    }


    // MARK: - Action
    @objc private func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func rightButtonTapped() {
        guard contentTextView?.text != "" else {
            leftBarButtonTapped()
            return
        }
        
        // TODO: - 做下提示
        let isSaved = PJCoreDataHelper.shared.addAnnotationContent(content: contentTextView!.text, model: annotationModel!)
        if isSaved {
            PJTapic.succee()
            leftBarButtonTapped()
        } else {
            PJTapic.error()
        }
    }
    
    
    private func willSetModel(_ model: AnnotationModel) {
        environmentLabel.text = model.environmentString
        healthLabel.text = "海拔：" + model.altitude + "米  步数：" + model.stepCount
        locationLabel.text = model.formatterAddress
        
    }
    
    
    @objc private func addPhotoButtonTapped() {
        PJTapic.tap()
        
        let actionSheet = UIAlertController.init(title: "选择照片来源", message: "从相册选择或者相机拍摄一张照片吧～", preferredStyle: .actionSheet)
        
        let photoAlbumAction = UIAlertAction(title: "相册", style: .default) { (action) in
            
        }
        
        let cameraAction = UIAlertAction(title: "相机", style: .default) { (action) in
            
        }
        
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            actionSheet.dismiss(animated: true)
        }
        
        actionSheet.addAction(photoAlbumAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancleAction)
        
        present(actionSheet, animated: true)
        
    }
    
    
    // MARK: - Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentTextView!.isFirstResponder {
            contentTextView?.resignFirstResponder()
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView.text != "" else {
            contentTextViewTipsLabel?.isHidden = false
            return
        }
        contentTextViewTipsLabel?.isHidden = true
    }

}
