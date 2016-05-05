//
//  DatePickerActionSheet.swift
//  iDoctors
//
//  Created by Valerio Ferrucci on 30/09/14.
//  Copyright (c) 2014 Tabasoft. All rights reserved.
//

import UIKit

protocol DataTimePickerViewControllerDelegate : class {
    
    func timePickerVCDismissed(date : NSDate?)
}

class PopTimeViewController : UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    weak var delegate : DataTimePickerViewControllerDelegate?
    
    var currentDate : NSDate? {
        didSet {
            updatePickerCurrentDate()
        }
    }
    
    convenience init() {
        
        self.init(nibName: "PopTimePicker", bundle: nil)
    }
    
    private func updatePickerCurrentDate() {
        
        if let _currentDate = self.currentDate {
            if let _datePicker = self.timePicker {
                _datePicker.date = _currentDate
            }
        }
    }
    
    @IBAction func okAction(sender: UIButton) {
        
        self.dismissViewControllerAnimated(false) {
            
            let nsdate = self.timePicker.date
            self.delegate?.timePickerVCDismissed(nsdate)
            // self.delegate?.hazardTypePickerVCDismissed(hazardTypeSelected)
            
        }
        
        //let nsdate = self.datePicker.date
        //self.delegate?.datePickerVCDismissed(nsdate)
    }
    
    override func viewDidLoad() {
        
        updatePickerCurrentDate()
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        self.delegate?.timePickerVCDismissed(nil)
    }
}
