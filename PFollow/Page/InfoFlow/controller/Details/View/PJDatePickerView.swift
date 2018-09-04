//
//  PJDatePickerView.swift
//  PFollow
//
//  Created by PJHubs on 2018/9/4.
//  Copyright © 2018年 pjpjpj. All rights reserved.
//

import UIKit


protocol PJDatePickerViewDelegate {
    func PJDatePickerViewCloseButtonTapped()
    func PJDatePickerViewOkButtonTapped(_ dateString: String)
}
extension PJDatePickerViewDelegate {
    func PJDatePickerViewCloseButtonTapped() {}
    func PJDatePickerViewOkButtonTapped(_ dateString: String) {}
}


class PJDatePickerView: UIView {

    @IBOutlet weak private var datePickerView: UIDatePicker!
    @IBOutlet weak private var closeButton: UIButton!
    @IBOutlet weak private var okButton: UIButton!
    
    var viewDelegate: PJDatePickerViewDelegate?
    
    
    // MARK: Instance
    class func newInstance() -> PJDatePickerView? {
        let nib = Bundle.main.loadNibNamed("PJDatePickerView", owner: nil, options: nil)
        if let view = nib?.first as? PJDatePickerView  {
            return view
        }
        return nil
    }
    
    
    override func awakeFromNib() {
//        datePickerView.maximumDate = Date()
//        datePickerView.minimumDate = DateFormatter().date(from: "1920-01-01")
        super.awakeFromNib()
    }

    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        viewDelegate?.PJDatePickerViewCloseButtonTapped()
    }
    
    
    @IBAction func okButtonTapped(_ sender: UIButton) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy/MM/dd"
        let dateString = timeFormatter.string(from: datePickerView.date) + " 来过"
        viewDelegate?.PJDatePickerViewOkButtonTapped(dateString)
    }
}
