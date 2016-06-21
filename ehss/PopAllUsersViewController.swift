
import UIKit
import CoreData


//MARK: Protocol Declaration for delegate
protocol PopAllUsersViewControllerDelegate : class {

    func popAllUsersPickerVCDismissed(value: NSString?)
    
}

class PopAllUsersViewController: UIViewController,UIPickerViewDelegate{
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btnOk: UIButton!
    
    var userSelected = ""

    var currentUser:NSString? {
        didSet {
            print("Current User: \(currentUser)")
        }
    }
    
    var users:[String] = ["User 1","User 2","User 3","User 4"]
    
    weak var delegate: PopAllUsersViewControllerDelegate?
    
    convenience init(){
        self.init(nibName: "PopAllUsersPicker", bundle: nil)
    }

    
    override func viewDidAppear(animated: Bool) {
        if let user = currentUser {
        
            self.users.append("User 1")
            self.users.append("User 2")
            self.users.append("User 3")
            
            //self.users.removeAll(keepCapacity: false)
        
        }
        
        
        for u in users {
            print("user list \(u)")
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.users.removeAll(keepCapacity: false)
        self.delegate?.popAllUsersPickerVCDismissed(nil)
    }
    
    @IBAction func btnOk(sender: AnyObject) {
        self.dismissViewControllerAnimated(false){
        
            self.delegate?.popAllUsersPickerVCDismissed(self.userSelected)
        }
    }
    
    //MARK: load user Picker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return users.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        
        //pag may pinipili sa pickerview
        return users[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        if component == 0 {
            userSelected = users[row]
            pickerView.reloadAllComponents()
            print("User: \(userSelected)", terminator: "")
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
