//
//  PopHazardTypePicker.swift
import UIKit

public class PopHazardTypePicker : NSObject, UIPopoverPresentationControllerDelegate, DataHazardTypePickerViewControllerDelegate {
    
    public typealias PopHazardTypePickerCallback = (newLocation : NSString, forTextField : UITextField)->()
    
    var hazardTypePickerVC : PopHazardTypeViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : PopHazardTypePickerCallback?
    var presented = false
    var offset : CGFloat = 8.0
    
    public init(forTextField: UITextField) {
        
        hazardTypePickerVC = PopHazardTypeViewController()
        self.textField = forTextField
        super.init()
    }
    
    public func pick(inViewController : UIViewController, initDate : NSString?, dataChanged : PopHazardTypePickerCallback, dataHazard:Int, dataId:String) {
        
        if presented {
            return  // we are busy
        }
        
        hazardTypePickerVC.delegate = self
        hazardTypePickerVC.currentHazardData = dataHazard
        hazardTypePickerVC.currentHazardDataId = dataId
        hazardTypePickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        hazardTypePickerVC.preferredContentSize = CGSizeMake(500,280)
        //companyPickerVC.currentDate = initDate
        
        popover = hazardTypePickerVC.popoverPresentationController
        if let _popover = popover {
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(self.offset,textField.bounds.size.height,0,0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            inViewController.presentViewController(hazardTypePickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    func hazardTypePickerVCDismissed(value : NSString?) {
        
        if let _dataChanged = dataChanged {
            if let v = value {
                _dataChanged(newLocation: v, forTextField: textField)
            }
            
        }
        
        presented = false
    }
}

