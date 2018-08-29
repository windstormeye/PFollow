//
//  PJAnnotationDetailsViewController.swift
//  PFollow
//
//  Created by pjpjpj on 2018/8/19.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit

class PJAnnotationDetailsViewController: PJBaseViewController, UIScrollViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    private var backScrollView: UIScrollView?
    private var newPhotoImage: UIImage?
    
    private var previousContentText: String?
    
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
        
        
        locationLabel.frame = CGRect(x: 10, y: 0,
                                     width: view.width - 20, height: navBarHeigt!)
        locationLabel.font = UIFont.boldSystemFont(ofSize: 22)
        locationLabel.textColor = .white
        locationLabel.numberOfLines = 2
        backScrollView?.addSubview(locationLabel)
        
        
        let envImageView = UIImageView(frame: CGRect(x: 10, y: locationLabel.bottom + 20,
                                                     width:15    , height: 20))
        backScrollView?.addSubview(envImageView)
        envImageView.image = UIImage(named: "annotation_details_env")
        
        
        environmentLabel.frame = CGRect(x: 35, y: envImageView.top,
                                        width: view.width - 20, height: 20)
        environmentLabel.textColor = .white
        environmentLabel.font = UIFont.boldSystemFont(ofSize: 15)
        backScrollView?.addSubview(environmentLabel)
        
        
        let heaImageView = UIImageView(frame: CGRect(x: 10, y: envImageView.bottom + 10,
                                                     width: 17.5, height: 20))
        backScrollView?.addSubview(heaImageView)
        heaImageView.image = UIImage(named: "annotation_details_altitude")
        
        
        healthLabel.frame = CGRect(x: 35, y: heaImageView.top,
                                   width: view.width - 20, height: 20)
        healthLabel.textColor = .white
        healthLabel.font = UIFont.boldSystemFont(ofSize: 15)
        backScrollView?.addSubview(healthLabel)
        
        
        contentTextView = UITextView(frame: CGRect(x: 10, y: heaImageView.bottom + 30,
                                                   width: view.width - 20, height: 200))
        backScrollView?.addSubview(contentTextView!)
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
        backScrollView?.addSubview(photoContentView!)
        photoContentView?.layer.cornerRadius = 8
        photoContentView?.layer.masksToBounds = true
        
        
        addPhotoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 80))
        backScrollView?.addSubview(addPhotoButton!)
        addPhotoButton?.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
        addPhotoButton?.center = photoContentView!.center
        addPhotoButton?.setTitleColor(.white, for: .normal)
        addPhotoButton?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        addPhotoButton?.setTitle("点击添加照片", for: .normal)
        
        
        
        backScrollView?.contentSize = CGSize(width: 0, height: view.height + 1)
    }
    
    
    private func initData() {
        let content = PJCoreDataHelper.shared.annotationContent(model: annotationModel!)
        if content == "" {
            contentTextViewTipsLabel?.isHidden = false
            contentTextViewTipsLabel?.text = "快来填写签到内容吧～"
        } else {
            contentTextViewTipsLabel?.isHidden = true
            contentTextView?.text = content
            previousContentText = content
        }
        
        if let photoImage = PJCoreDataHelper.shared.annotationImage(model: annotationModel!) {
            clipNewPhotoImage(photoImage)
            newPhotoImage = photoImage
        }
        
    }


    // MARK: - Action
    @objc private func leftBarButtonTapped() {
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

        
        // TODO: - 做下提示
        let isSaved = PJCoreDataHelper.shared.addAnnotationContent(content: contentTextView!.text, model: annotationModel!)
    
        if newPhotoImage != nil {
            let isPhotoImage = PJCoreDataHelper.shared.addAnnotationPhoto(photoImage: newPhotoImage!,
                                                                          model: annotationModel!)
            if isPhotoImage && isSaved {
                PJTapic.succee()
                leftBarButtonTapped()
            } else {
                PJTapic.error()
            }
        } else {
            if isSaved {
                PJTapic.succee()
                leftBarButtonTapped()
            } else {
                PJTapic.error()
            }
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
        backScrollView?.contentSize = CGSize(width: 0,
                                             height: photoContentView!.bottom + 10 + headerView!.height)
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

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        if picker.sourceType == .photoLibrary {
            clipNewPhotoImage(image)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - setter & getter
    private func willSetModel(_ model: AnnotationModel) {
        environmentLabel.text = model.environmentString
        healthLabel.text = "海拔：" + model.altitude + "米  步数：" + model.stepCount
        locationLabel.text = model.formatterAddress
        
    }
}
