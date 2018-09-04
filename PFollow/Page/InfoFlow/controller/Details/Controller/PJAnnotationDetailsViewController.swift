//
//  PJAnnotationDetailsViewController.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/19.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

class PJAnnotationDetailsViewController: PJBaseViewController, UIScrollViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PJDatePickerViewDelegate {

    var annotationView: PJHomeMapAnnotationView?
    
    private var environmentLabel: UILabel?
    private var healthLabel: UILabel?
    private var locationLabel: UILabel?
    private var envImageView: UIImageView?
    private var heaImageView: UIImageView?
    private var contentTextView: UITextView?
    private var addTimeButton: UIButton?
    
    private var photoContentView: UIView?
    private var addPhotoButton: UIButton?
    private var contentTextViewTipsLabel: UILabel?
    private var backScrollView: UIScrollView?
    private var newPhotoImage: UIImage?
    
    private var contentTextViewLeftPadding: CGFloat?
    
    private var previousContentText: String?
    private var updateTimeString: String?
    
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
        
        backScrollView = UIScrollView(frame: CGRect(x: 0, y: headerView!.bottom,
                                                        width: view.width, height: view.height))
        backScrollView?.delegate = self
        backScrollView?.showsVerticalScrollIndicator = false
        view.addSubview(backScrollView!)
        
        
        locationLabel = UILabel(frame: CGRect(x: 10, y: 0,
                                              width: view.width - 20, height: navBarHeigt!))
        locationLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        locationLabel?.textColor = .white
        locationLabel?.numberOfLines = 2
        backScrollView?.addSubview(locationLabel!)
        
        
        envImageView = UIImageView(frame: CGRect(x: 10, y: locationLabel!.bottom + 20,
                                                 width:15, height: 20))
        backScrollView?.addSubview(envImageView!)
        envImageView?.image = UIImage(named: "annotation_details_env")
        
        
        environmentLabel = UILabel(frame: CGRect(x: 35, y: envImageView!.top,
                                                 width: view.width - 20, height: 20))
        environmentLabel?.textColor = .white
        environmentLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        backScrollView?.addSubview(environmentLabel!)
        
        
        heaImageView = UIImageView(frame: CGRect(x: 10, y: envImageView!.bottom + 10,
                                                 width: 17.5, height: 20))
        backScrollView?.addSubview(heaImageView!)
        heaImageView?.image = UIImage(named: "annotation_details_altitude")
        
        
        healthLabel = UILabel(frame: CGRect(x: 35, y: heaImageView!.top,
                                            width: view.width - 20, height: 20))
        healthLabel?.textColor = .white
        healthLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        backScrollView?.addSubview(healthLabel!)
        
        
        contentTextView = UITextView(frame: CGRect(x: 10, y: heaImageView!.bottom + 30,
                                               width: view.width - 20, height: 200))
        backScrollView?.addSubview(contentTextView!)
        contentTextView?.delegate = self
        contentTextView?.backgroundColor = PJRGB(r: 50, g: 50, b: 50)
        contentTextView?.tintColor = .white
        contentTextView?.layer.cornerRadius = 8
        contentTextView?.font = UIFont.systemFont(ofSize: 20, weight: .light)
        contentTextView?.textColor = .white
        contentTextView?.layer.masksToBounds = true
        
        
        contentTextViewLeftPadding = contentTextView!.textContainer.lineFragmentPadding
        
        
        contentTextViewTipsLabel = UILabel(frame: CGRect(x: 5, y: 10,
                                                         width: contentTextView!.width, height: 20))
        contentTextView?.addSubview(contentTextViewTipsLabel!)
        contentTextViewTipsLabel?.font = contentTextView!.font
        contentTextViewTipsLabel?.textColor = contentTextView!.textColor
        
        
        photoContentView = UIView(frame: CGRect(x: contentTextView!.left,
                                                y: contentTextView!.bottom + 20,
                                                width: contentTextView!.width,
                                                height: 100))
        photoContentView?.backgroundColor = contentTextView!.backgroundColor
        backScrollView?.addSubview(photoContentView!)
        photoContentView?.layer.cornerRadius = 8
        photoContentView?.layer.masksToBounds = true
        
        
        addPhotoButton = UIButton(frame: CGRect(x: 0, y: 0,
                                                width: 200, height: 80))
        photoContentView?.addSubview(addPhotoButton!)
        addPhotoButton?.addTarget(self,
                                  action: #selector(addPhotoButtonTapped),
                                  for: .touchUpInside)
        addPhotoButton?.centerX = view.centerX - 10
        addPhotoButton?.top = (photoContentView!.height - 80) / 2
        addPhotoButton?.setTitleColor(.white, for: .normal)
        addPhotoButton?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        addPhotoButton?.setTitle("点击添加照片", for: .normal)
        
        
        addTimeButton = UIButton(frame: CGRect(x: photoContentView!.right - 30,
                                               y: photoContentView!.bottom - headerView!.height - PJStatusHeight,
                                               width: 30, height: 30))
        backScrollView?.addSubview(addTimeButton!)
        addTimeButton?.addTarget(self,
                                 action: #selector(showSelectTimeList),
                                 for: .touchUpInside)
        addTimeButton?.setImage(UIImage(named: "annotation_details_addTime"),
                                for: .normal)
        
    }
    
    private func initData() {
        title = annotationView?.model?.createdTimeString
        locationLabel?.text = annotationView?.model?.formatterAddress
        
        // MARK: coreData
        let content = PJCoreDataHelper.shared.annotationContent(model: annotationView!.model!)
        if content == "" {
            contentTextViewTipsLabel?.isHidden = false
            contentTextViewTipsLabel?.text = "快来填写签到内容吧～"
            
            updateBackScrollViewContentSize()
        } else {
            contentTextViewTipsLabel?.isHidden = true
            contentTextView?.text = content
            previousContentText = content
            
            updateView(showTips: false)
        }
        
        if let photoImage = PJCoreDataHelper.shared.annotationImage(model: annotationView!.model!) {
            clipNewPhotoImage(photoImage)
            newPhotoImage = photoImage
        }
        
        // MARK: update frame
        if annotationView?.model?.environmentString == "-" {
            environmentLabel?.isHidden = true
            healthLabel?.isHidden = true
            envImageView?.isHidden = true
            heaImageView?.isHidden = true
            
            contentTextView?.top = locationLabel!.bottom + 10
            photoContentView?.top = contentTextView!.bottom + 10
        } else {
            addTimeButton?.isHidden = true

            environmentLabel?.text = annotationView?.model?.environmentString
            healthLabel?.text = "海拔：" + annotationView!.model!.altitude + "米  步数：" + annotationView!.model!.stepCount
        }
    }


    // MARK: - Action
    @objc private func showSelectTimeList() {
        datePickerView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.datePickerView.bottom = self.view.height
        }) { (finished) in
            PJTapic.tap()
        }
    }
    
    
    @objc private func leftBarButtonTapped() {
        if title!.contains("/") {
            annotationView?.model?.createdTimeString = title!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PJNotificationName_updateCallouView),
                                            object: nil,
                                            userInfo: [
                                                "time": title!,
                                                ])
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func rightButtonTapped() {
        var isCanSave = 0
        
        if contentTextView?.text != "" {
            isCanSave += 1
        }
        
        if newPhotoImage != nil {
            isCanSave += 1
        }
        
        if  isCanSave < 1 {
            print("签到内容和照片必须选一个哦～")
            PJTapic.error()
            return
        }

        
        var isUpdateTime = true
        var isSaved = true
        var isPhotoImage = true
        
        
        // TODO: 做下提示
        if title!.contains("/") {
            let formatString = "longitude=\(annotationView!.model!.longitude) and latitude=\(annotationView!.model!.latitude)"
            isUpdateTime = PJCoreDataHelper.shared.updateAnnotation(formatString: formatString, updateTime: title!)
        }
        
        
        
        isSaved = PJCoreDataHelper.shared.addAnnotationContent(content: contentTextView!.text, model: annotationView!.model!)
    
        if newPhotoImage != nil {
            isPhotoImage = PJCoreDataHelper.shared.addAnnotationPhoto(photoImage: newPhotoImage!,
                                                                          model: annotationView!.model!)
        }
        
        
        if isPhotoImage && isSaved && isUpdateTime {
            PJTapic.succee()
            leftBarButtonTapped()
        } else {
            PJTapic.error()
        }
    }
    
    
    @objc private func addPhotoButtonTapped() {
        PJTapic.tap()
        
        let actionSheet = UIAlertController.init(title: "选择照片来源", message: "从相册选择或者相机拍摄一张照片吧～", preferredStyle: .actionSheet)
        
        let photoAlbumAction = UIAlertAction(title: "相册", style: .default) { (action) in
            self.initPhotoPicker()
        }
        
        let cameraAction = UIAlertAction(title: "相机", style: .default) { (action) in
            self.initCameraPicker()
        }
        
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            actionSheet.dismiss(animated: true)
        }
        
        actionSheet.addAction(photoAlbumAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancleAction)
        
        present(actionSheet, animated: true)
        
    }
    
    
    private func initPhotoPicker() {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        present(photoPicker, animated: true)
    }
    
    
    private func initCameraPicker() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.sourceType = .camera
            present(cameraPicker, animated: true)
        } else {
            // TODO: 不支持拍照
        }
    }
    
    
    @objc func image(image:UIImage,
                     didFinishSavingWithError error:NSError?,
                     contextInfo:AnyObject) {
        if error != nil {
            print("保存失败")
        } else {
            clipNewPhotoImage(image)
            print("保存成功")
        }
    }
    
    
    private func updateBackScrollViewContentSize() {
        if annotationView!.model!.createdTimeString.contains("/") {
            backScrollView?.contentSize = CGSize(width: 0,
                                                 height: photoContentView!.bottom + 10 + headerView!.height)
        } else {
            backScrollView?.contentSize = CGSize(width: 0,
                                                 height: addTimeButton!.bottom + 10 + headerView!.height)
        }
        
        if backScrollView!.contentSize.height < view.height {
            backScrollView?.contentSize = CGSize(width: 0,
                                                 height: view.height + 1)
        }
    }
    
    
    func clipNewPhotoImage(_ photoImage:UIImage) {
        addPhotoButton?.isHidden = true
        
        let photoImageSize = photoImage.size
        let radio = photoImageSize.width / photoImageSize.height
        let photoImageView = UIImageView(frame: CGRect(x: 5, y: 5,
                                                       width: photoContentView!.width - 10,
                                                       height: photoContentView!.width / radio))
        photoImageView.image = photoImage
        photoContentView?.height = photoImageView.height + 10
        photoImageView.layer.cornerRadius = 8
        photoImageView.layer.masksToBounds = true
        
        newPhotoImage = photoImage
        photoContentView?.addSubview(photoImageView)
        
        updateBackScrollViewContentSize()
    }
    
    
    private func updateView(showTips: Bool) {
        if showTips {
            UIView.animate(withDuration: 0.25, animations: {
                self.contentTextView?.height = 200
            }) { (finished) in
                if finished {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.photoContentView?.top = self.contentTextView!.bottom + 20
                        self.addTimeButton?.top = self.photoContentView!.bottom + 10
                    }, completion: { (finished) in
                        if finished {
                            PJTapic.tap()
                            
                            self.updateBackScrollViewContentSize()
                        }
                    })
                }
            }
        } else {
            let textSize = contentTextView!.attributedText.boundingRect(with: CGSize(width: contentTextView!.width - 2 * contentTextViewLeftPadding!, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            
            UIView.animate(withDuration: 0.25, animations: {
                self.contentTextView?.height = textSize.size.height + self.contentTextViewLeftPadding! * 3.5
            }) { (finished) in
                if finished {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.photoContentView?.top = self.contentTextView!.bottom + 20
                        self.addTimeButton?.top = self.photoContentView!.bottom + 10
                    }, completion: { (finished) in
                        if finished {
                            PJTapic.tap()
                            
                            self.updateBackScrollViewContentSize()
                        }
                    })
                }
            }
        }
    }
    
    
    func changeDatePickerViewStuts() {
        if datePickerView.bottom == view.height {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                            self.datePickerView.top = self.view.height
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            self.datePickerView.bottom = self.view.height
            }, completion: nil)
        }
    }
    
    
    // MARK: - Delegate
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text != "" else {
            return
        }
        updateView(showTips: false)
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView.text != "" else {
            contentTextViewTipsLabel?.isHidden = false
            updateView(showTips: true)
            return
        }
        contentTextViewTipsLabel?.isHidden = true
    }

    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        if picker.sourceType == .photoLibrary {
            clipNewPhotoImage(image)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func PJDatePickerViewOkButtonTapped(_ dateString: String) {
        changeDatePickerViewStuts()
        title = dateString
    }
    
    
    func PJDatePickerViewCloseButtonTapped() {
        changeDatePickerViewStuts()
    }
    
    
    // MARK: lazy load {
    lazy var datePickerView: PJDatePickerView = {
        let datePickerView = PJDatePickerView.newInstance()
        datePickerView?.height = 250
        datePickerView?.isHidden = true
        datePickerView?.top = view.height
        datePickerView?.viewDelegate = self
        PJInsertRoundingCorners(datePickerView!)
        
        view.addSubview(datePickerView!)
        return datePickerView!
    }()
}
