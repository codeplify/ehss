import UIKit

public class PopDeptPicker : NSObject, UIPopoverPresentationControllerDelegate, DataDeptPickerViewControllerDelegate {
    
    public typealias PopDeptPickerCallback = (newDept : NSString, forTextField : UITextField)->()
    
    var deptPickerVC : PopDeptViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : PopDeptPickerCallback?
    var presented = false
    var offset : CGFloat = 8.0
    
    public init(forTextField: UITextField) {
        
        deptPickerVC = PopDeptViewController()
        self.textField = forTextField
        super.init()
    }
    
    public func pick(inViewController : UIViewController, initDate : NSString?, dataChanged : PopDeptPickerCallback, company:Int) {
        
        if presented {
            return  // we are busy
        }
        
        deptPickerVC.delegate = self
        deptPickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        deptPickerVC.preferredContentSize = CGSizeMake(500,280)
        //companyPickerVC.currentDate = initDate
        deptPickerVC.currentCompany = company //set company value
        popover = deptPickerVC.popoverPresentationController
        if let _popover = popover {
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(self.offset,textField.bounds.size.height,0,0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            inViewController.presentViewController(deptPickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    func deptPickerVCDismissed(value : NSString?) {
        
        if let _dataChanged = dataChanged {
            
            
            if let v = value {
                _dataChanged(newDept: v, forTextField: textField)
            }
            
        }
        
        presented = false
    }
}

