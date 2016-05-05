import UIKit

public class PopLocationPicker : NSObject, UIPopoverPresentationControllerDelegate, DataLocationPickerViewControllerDelegate {
    
    public typealias PopLocationPickerCallback = (newLocation : NSString, forTextField : UITextField)->()
    
    var locationPickerVC : PopLocationViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : PopLocationPickerCallback?
    var presented = false
    var offset : CGFloat = 8.0
    
    public init(forTextField: UITextField) {
        
        locationPickerVC = PopLocationViewController()
        self.textField = forTextField
        super.init()
    }
    
    public func pick(inViewController : UIViewController, initDate : NSString?, dataChanged : PopLocationPickerCallback) {
        
        if presented {
            return  // we are busy
        }
        
        locationPickerVC.delegate = self
        locationPickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        locationPickerVC.preferredContentSize = CGSizeMake(500,280)
        //companyPickerVC.currentDate = initDate
        
        popover = locationPickerVC.popoverPresentationController
        if let _popover = popover {
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(self.offset,textField.bounds.size.height,0,0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            inViewController.presentViewController(locationPickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    func locationPickerVCDismissed(value : NSString?) {
        
        if let _dataChanged = dataChanged {
            
            
            if let v = value {
                _dataChanged(newLocation: v, forTextField: textField)
            }
            
        }
        
        presented = false
    }
}

