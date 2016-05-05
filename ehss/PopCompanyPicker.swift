import UIKit

public class PopCompanyPicker : NSObject, UIPopoverPresentationControllerDelegate, DataCompanyPickerViewControllerDelegate {
    
    public typealias PopCompanyPickerCallback = (newCompany : NSString, newVal:NSInteger, forTextField : UITextField)->()
    
    var companyPickerVC : PopCompanyViewController
    var popover : UIPopoverPresentationController?
    var textField : UITextField!
    var dataChanged : PopCompanyPickerCallback?
    var presented = false
    var offset : CGFloat = 8.0
    
    public init(forTextField: UITextField) {
        
        companyPickerVC = PopCompanyViewController()
        self.textField = forTextField
        super.init()
    }
    
    public func pick(inViewController : UIViewController, initDate : NSString?, dataChanged : PopCompanyPickerCallback) {
        
        if presented {
            return  // we are busy
        }
        
        companyPickerVC.delegate = self
        companyPickerVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        companyPickerVC.preferredContentSize = CGSizeMake(500,280)
        //companyPickerVC.currentDate = initDate
        
        popover = companyPickerVC.popoverPresentationController
        if let _popover = popover {
            
            _popover.sourceView = textField
            _popover.sourceRect = CGRectMake(self.offset,textField.bounds.size.height,0,0)
            _popover.delegate = self
            self.dataChanged = dataChanged
            inViewController.presentViewController(companyPickerVC, animated: true, completion: nil)
            presented = true
        }
    }
    
    public func adaptivePresentationStyleForPresentationController(PC: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    func companyPickerVCDismissed(value : NSString?, companyId:NSInteger?) {
        
        if let _dataChanged = dataChanged {
            
            println("Company Id passed:\(companyId)")
            
            if let v = value {
                
                if let i = companyId {
                     _dataChanged(newCompany: v, newVal:i, forTextField: textField)
                }
               
            }
            
        }
        
        presented = false
    }
}

