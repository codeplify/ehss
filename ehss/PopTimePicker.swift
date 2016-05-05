//
//  DataPicker.swift
//  iDoctors
//
//  Created by Valerio Ferrucci on 30/09/14.
//  Copyright (c) 2014 Tabasoft. All rights reserved.
//

import UIKit

public class PopTimePicker : NSObject, UIPopoverPresentationControllerDelegate, DataTimePickerViewControllerDelegate {
    
    public typealias PopTimePickerCallback = (newDate : NSDate, forTextField : UITextField)->()
    
    var timePickerVC : PopTimeViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : PopTimePickerCallback?
    var presented = false
    var offset : CGFloat = 8.0
    
    public init(forTextField: UITextField) {
        
        timePickerVC = PopTimeViewController()
        self.textField = forTextField
        super.init()
    }
    
    public func pick(inViewController : UIViewController, initDate : NSDate?, dataChanged : PopTimePickerCallback) {
        
        if presented {
            return  // we are busy
        }
        
        timePickerVC.delegate = self
        timePickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        timePickerVC.preferredContentSize = CGSizeMake(500,280)
        timePickerVC.currentDate = initDate
        
        popover = timePickerVC.popoverPresentationController
        if let _popover = popover {
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(self.offset,textField.bounds.size.height,0,0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            inViewController.presentViewController(timePickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    func timePickerVCDismissed(date : NSDate?) {
        
        if let _dataChanged = dataChanged {
            
            if let _date = date {
                
                _dataChanged(newDate: _date, forTextField: textField)
                
            }
        }
        presented = false
    }
}

