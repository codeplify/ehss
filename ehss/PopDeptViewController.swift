
import UIKit
import CoreData

protocol DataDeptPickerViewControllerDelegate : class {
    
    func deptPickerVCDismissed(value : NSString?)
}

class PopDeptViewController : UIViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var deptPicker: UIPickerView!
    
    var departmentSelected = ""
    
    var currentCompany : NSInteger? {
        didSet {
            print("Current Company : \(currentCompany)")
        }
    }
    
    
    var department:[String] = [String]()
    
    weak var delegate : DataDeptPickerViewControllerDelegate?
    
    var currentDate : NSString? {
        didSet {
            //updatePickerCurrentDate()
            
        }
    }
    
    convenience init() {
        
        self.init(nibName: "PopDeptPicker", bundle: nil)
    }
    
    private func updatePickerCurrentDate() {
        
        if let _currentDate = self.currentDate {
            if let _datePicker = self.deptPicker {
                
            }
        }
    }
    
    @IBAction func okAction(sender: UIButton) {
        
        self.dismissViewControllerAnimated(false) {
            
            //let nsdate = self.datePicker.date
            self.delegate?.deptPickerVCDismissed(self.departmentSelected)
            
        }
        
    }
    
    /*override func viewDidLoad() {
        
        //load value array here
        updatePickerCurrentDate()
        
        
    }*/
    
    override func viewDidAppear(animated: Bool) {
        if let company = currentCompany {
            
            let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            let context:NSManagedObjectContext = AppDel.managedObjectContext!
            let request = NSFetchRequest(entityName: "Unit")
            
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "parent_id = %@", "\(company)")
            //add predicate
            let results:NSArray = try! context.executeFetchRequest(request)
            
            print("inside view didload \(company)")
            
            
            //clear department
            
            self.department.removeAll(keepCapacity: false)
            
            if results.count>0 {
                
                for res in results{
                    
                    let dept = res.valueForKey("name") as! String
                    self.department.append(dept)
                    print("\(dept) Parent Id: \(company)")
                    
                }
                
            }
        }
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.department.removeAll(keepCapacity: false)
        self.delegate?.deptPickerVCDismissed(nil)        
    }
    
    //for datepicker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return department.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        
                //pag may pinipili sa pickerview
        return department[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if component == 0 {
            departmentSelected = department[row]
            pickerView.reloadAllComponents()
            print("Dept: \(departmentSelected)", terminator: "")
        }
        
       
    }
    
    
    
    
    
}
