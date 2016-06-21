//
//  PopAllUsers.swift
//  ehss
//
//  Created by IOS1-PC on 20/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit

public class PopAllUsersPicker : NSObject, UIPopoverPresentationControllerDelegate,PopAllUsersViewControllerDelegate{

    public typealias PopAllUsersCallback = (newUser: NSString,forTextField:UITextField)->()
    
    
    var userPickerVC : PopAllUsersViewController
    var popover:UIPopoverPresentationController?
    var textField:UITextField!
    var dataChanged : PopAllUsersCallback?
    var presented = false
    var offset: CGFloat = 8.0
    
    public init(forTextField: UITextField){
        userPickerVC = PopAllUsersViewController()
        self.textField = forTextField
        super.init()
    }
    
    
    public func pick(inViewController: UIViewController, initDate: NSString?, dataChanged:PopAllUsersCallback, user:String){
        
        if presented{
            return
        }
        
        userPickerVC.delegate = self
        userPickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        userPickerVC.preferredContentSize = CGSizeMake(500,280)
        userPickerVC.currentUser = user
        
        popover = userPickerVC.popoverPresentationController
        
        if let _popover = popover {
        
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(self.offset, textField.bounds.size.height, 0, 0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            inViewController.presentViewController(userPickerVC,animated: true, completion: nil)
        }
    }
    
    
    public func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    //MARK: Delegate protocol
    
    func popAllUsersPickerVCDismissed(value: NSString?) {
        if let _dataChanged = dataChanged {
            if let v = value {
                _dataChanged(newUser: v, forTextField: textField)
            }
        }
        
        presented = false
    }
}
