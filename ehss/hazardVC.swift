import UIKit
import CoreData

class hazardVC: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    var popDatePicker : PopDatePicker?
    var popCompanyPicker: PopCompanyPicker?
    var popDeptPicker: PopDeptPicker?
    var popLocationPicker: PopLocationPicker?
    var popHazardTypePicker: PopHazardTypePicker?
    var popHazardImpactPicker: PopHazardTypePicker?
    var popHazardImpactPicker2: PopHazardTypePicker?
    var popTimePicker: PopDatePicker?
    
    var userPref = NSUserDefaults.standardUserDefaults()
    
    
    @IBOutlet weak var lblUserFull: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    @IBOutlet weak var btnAttachment: UIButton!
    
    @IBAction func btnAttached(sender: UIButton) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func currentDate()->String{
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
                
        return "\(dateFormatter.stringFromDate(date))"
    }
    
    //static var hazard:Hazard = Hazard()
    
    struct Hazard {
        var time:String
        var date:String
        var company:Int
        var department:Int
        var location:Int
        var hazardType:Int
        var hazardImpact:Int
        var hazardImpact2:Int
        var hazardName:String
        var hazardDescription:String
        
    }

    var hazardObject = Hazard(time: "", date: "", company: 0, department: 0, location: 0, hazardType: 0, hazardImpact: 0, hazardImpact2: 0, hazardName: "", hazardDescription: "")
    
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtDept: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtHazardType: UITextField!
    @IBOutlet weak var txtHazardImpact: UITextField!
    @IBOutlet weak var txtHazardImpact2: UITextField!
    @IBOutlet weak var hazardName: UITextField!
    @IBOutlet weak var hazardDescription: UITextField!
    @IBOutlet weak var hazardNameText: UITextField!
    @IBOutlet weak var hazardDescText: UITextField!

    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var btnListAll: UIBarButtonItem!
    
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "AllUser")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "email = %@", userPref.valueForKey("ehss_username") as! String)
        
        
        
        do{
            
            let result:NSArray = try context.executeFetchRequest(request)
            
            //print("username count : \(result.count)")
            
            if result.count > 0 {
                let r = result[0] as! NSManagedObject
                
                lblUserFull.text = r.valueForKey("name") as? String
                
                //print("username \(lblUserFull.text)")
            }
            
        }catch{
        
        }
        
        lblDate.text = currentDate()
        
        
        popDatePicker = PopDatePicker(forTextField: txtDate)
        txtDate.delegate = self
        
        popCompanyPicker = PopCompanyPicker(forTextField:txtCompany)
        txtCompany.delegate = self
        
        popDeptPicker = PopDeptPicker(forTextField: txtDept)
        txtDept.delegate = self
        
        popLocationPicker = PopLocationPicker(forTextField: txtLocation)
        txtLocation.delegate = self
        
        popHazardTypePicker = PopHazardTypePicker(forTextField: txtHazardType)
        txtHazardType.delegate = self
        
        popHazardImpactPicker = PopHazardTypePicker(forTextField: txtHazardImpact)
        txtHazardImpact.delegate = self
        
        popHazardImpactPicker2 = PopHazardTypePicker(forTextField: txtHazardImpact2)
        txtHazardImpact2.delegate = self
        
        popTimePicker = PopDatePicker(forTextField: txtTime)
        txtTime.delegate = self
        
        if self.revealViewController() != nil {
            btnListAll.target = self.revealViewController()
            btnListAll.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //hazardName.delegate = self
        //hazardDescription.delegate = self
        
    }
    
    func resign() {
        
        txtDate.resignFirstResponder()
        txtCompany.resignFirstResponder()
        txtDept.resignFirstResponder()
        txtLocation.resignFirstResponder()
        txtHazardType.resignFirstResponder()
        txtHazardImpact2.resignFirstResponder()
        txtTime.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField!){
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if (textField === txtDate) {
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = formatter.dateFromString(txtDate.text!)
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
                
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
                
                self.hazardObject.date = self.txtDate.text! as String
                print("Hazard object value: \(self.hazardObject.date)", terminator: "")
            }
            
            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            
            return false
        
          
        } else if (textField === txtCompany) {
            resign()
            let initCompany: NSString? = txtCompany.text
            
            let dataChangedCallback : PopCompanyPicker.PopCompanyPickerCallback = {
                ( newCompany: NSString, newVal : NSInteger,  forTextField: UITextField) -> () in
                
                
               forTextField.text = "\(newCompany)"
                
                self.hazardObject.company = self.getCompany(newCompany as String)
                //print("Company: \(self.hazardObject.company)")
               self.txtDept.text = ""
            }
            
            popCompanyPicker!.pick(self, initDate:initCompany, dataChanged: dataChangedCallback)
            
            
            return false;
        }else if (textField === txtDept) {
            resign()
           
            let initDept:NSString? = txtDept.text
            let dataChangedCallback : PopDeptPicker.PopDeptPickerCallback = {
                ( newVal: NSString, forTextField: UITextField ) -> () in
                forTextField.text = "\(newVal)"
                
                self.hazardObject.department = self.getDepartment("\(newVal)")
                
            }
            
            let companyIdVal:Int? = self.getCompany(txtCompany.text! as String)
            
            
        
            popDeptPicker!.pick(self, initDate: initDept, dataChanged: dataChangedCallback, company:companyIdVal!)
            
            return false;
            
        }else if (textField === txtLocation){
            resign()
            
            let initLocation:NSString? = txtLocation.text
            let dataChangedCallback: PopLocationPicker.PopLocationPickerCallback = {
                (newVal:NSString, forTextField:UITextField) -> () in
                forTextField.text = "\(newVal)"
                
                self.hazardObject.location = self.getLocation("\(newVal)")
                
                print("Location \(self.hazardObject.location)", terminator: "");
                
            }
            
            popLocationPicker!.pick(self, initDate: initLocation, dataChanged: dataChangedCallback)
            
            return false
        
        }else if(textField === txtHazardType){
            resign()
            
            let initHazardType:NSString? = txtHazardType.text
            let dataChangedCallback: PopHazardTypePicker.PopHazardTypePickerCallback = {
                (newVal:NSString, forTextField:UITextField) -> () in
                forTextField.text = "\(newVal)"
                
                self.hazardObject.hazardType = self.getHazardType("\(newVal)")
            }
            
            popHazardTypePicker!.pick(self, initDate: initHazardType, dataChanged: dataChangedCallback, dataHazard:0, dataId:"")
            return false
            
        }else if(textField === txtHazardImpact){
            
            let initHazardTypeImpact:NSString? = txtHazardImpact.text
            let dataChangedCallback: PopHazardTypePicker.PopHazardTypePickerCallback = {
                (newVal:NSString, forTextField:UITextField) -> () in
                forTextField.text = "\(newVal)"
                
                self.hazardObject.hazardImpact = self.getHazardImpact("\(newVal)")
            }
            
            popHazardImpactPicker!.pick(self, initDate: initHazardTypeImpact, dataChanged: dataChangedCallback, dataHazard:1, dataId:"")
            return false;
            
            
        }else if(textField === txtHazardImpact2){
            
            let initHazardTypeImpact2: NSString? = txtHazardImpact2.text
            let dataChangedCallback:PopHazardTypePicker.PopHazardTypePickerCallback = {
                (newVal:NSString, forTextField:UITextField) -> () in
                forTextField.text = "\(newVal)"
                
                self.hazardObject.hazardImpact2 = self.getHazardImpact("\(newVal)")
            }
            
            let dataString = txtHazardImpact.text! as String
            
            //print("data string value: \(dataString)")
            
            popHazardImpactPicker2!.pick(self, initDate: initHazardTypeImpact2, dataChanged: dataChangedCallback, dataHazard: 2, dataId:dataString)
            
            return false;
        }else {
            return true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        hazardDescription.resignFirstResponder()
        hazardNameText.resignFirstResponder()
        return true;
    }
    
    var kbHeight:CGFloat!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver("keyboardWillHide:", selector: "keyboardWillHide", name: UIKeyboardWillHideNotification, object: nil)
        
    } */
    
   
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        
        //view.endEditing(true)
        /*
         if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey])?.CGRectValue(){
                kbHeight = keyboardSize.height
                self.animateTextField(true)
            }
         }
         */
        
        
    }
    
    //func keyboardWillShow(notification: NSNotification){
        
        //view.endEditing(true)
        
        /*let userInfor = notification.userInfo
        let keyboardSize = (userInfor![UIKeyboardFrameBeginUserInfoKey])?.CGRectValue()
        
        print("keybaord size \(keyboardSize)")
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey])?.CGRectValue(){
                kbHeight = keyboardSize.height
                self.animateTextField(true)
                 print("keybaord size \(keyboardSize)")
            }
        } */
        
        /*if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue(){
            self.view.frame.origin.y -= keyboardSize.height
        }*/
        
       /* self.scrollview.scrollEnabled = true
        
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize?.height)!, 0.0)
        
        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets
        
        var aRect:CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = activeField {
            if(!CGRectContainsPoint(aRect, activeField!.frame.origin)){
                self.scrollview.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
        
        
    }*/
    
    /*func animateTextField(up: Bool){
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    
    } */
    
    
    //func keyboardWillHide(notification: NSNotification){
        //self.animateTextField(false)
        
        /*if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue(){
            self.view.frame.origin.y += keyboardSize.height
        }*/
        
        
        /*let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -(keyboardSize?.height)!, 0.0)
        self.scrollview.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollview.scrollEnabled = false*/
        
        
    //}

    @IBAction func openDate(sender: UIButton){
        
    }
    
    @IBAction func btnSubmitHazard(sender: UIButton) {
       
        
        if validateHazard() {
            print("Date: \(hazardObject.date)")
            //println("Time: \(hazardObject.time)")
            print("Company: \(hazardObject.company)")
            print("Location: \(hazardObject.location)")
            print("Department: \(hazardObject.department)")
            print("Hazard Type: \(hazardObject.hazardType)")
            print("Hazard Impact: \(hazardObject.hazardImpact)")
            print("Hazard Impact 2:\(hazardObject.hazardImpact2)")
            print("Hazard Name: \(hazardNameText.text)")
            print("Hazard Description:  \(hazardDescText.text)")
            
            hazardSave(hazardObject)
            
        }else{
             print(" fill out all of the data")
        }
        
        
        
    }
    
    func validateHazard() -> Bool{
        
        var validated = true;
        
        if txtDate.text == ""{
            print("Date is empty")
            validated = false
            return validated;
        }
        
        if txtTime.text == "" {
            //validated = false
            print("Time is empty")
             return validated;
        }
        
        if txtCompany.text == "" {
            print("Company is empty")
            validated = false
             return validated;
        }
        
        if txtLocation.text == "" {
            print("Department is empty")
            validated = false
             return validated;
        }
        
        if txtHazardType.text == "" {
            print("Hazard Type is empty")
            validated = false
             return validated;
        }
        
        if txtHazardImpact.text == "" {
            print("Hazard impact is empty")
            validated = false
             return validated;
        }
        
        if txtHazardImpact2.text == "" {
            print("Hazard impact 2 is empty")
            validated = false
             return validated;
        }
        
        if hazardName.text == "" {
            print("Hazard name is empty")
            validated = false
             return validated;
        }
        
        if hazardDescription.text == "" {
            validated = false
            return validated;
        }
        
        return validated;
    }
    
    
    func hazardSave(h:Hazard){
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let newHazard = NSEntityDescription.insertNewObjectForEntityForName("Hazard", inManagedObjectContext: context)
        
        //convert integer value to string
        
      
        
               var userId:Int = 0
        let imageAtt:String = ""
        var username:String = ""
        var password:String = ""
        var subdomain:String = ""
        
        if userPref.valueForKey("ehss_username") != nil  && userPref.valueForKey("ehss_password") != nil && userPref.valueForKey("subdomain") != nil {
            username = userPref.valueForKey("ehss_username") as! String
            password = userPref.valueForKey("ehss_password") as! String
            subdomain = userPref.valueForKey("subdomain") as! String
            userId = getUserId(username)
            
        }
        
       print("hazard object id \(newHazard.objectID)")

        //newHazard.setValue(newHazard.objectID, forKey: "id")
        newHazard.setValue(h.company, forKey: "company_id")
        newHazard.setValue(h.date, forKey: "date")
        newHazard.setValue(h.department, forKey: "department")
        newHazard.setValue(hazardDescription.text, forKey: "desc")
        newHazard.setValue(subdomain, forKey: "domain") //get from shared preference
        newHazard.setValue(h.hazardType, forKey: "hazard_type")
        //newHazard.setValue(, forKey: "id") // default or autocreate
        newHazard.setValue("", forKey: "image") // load camera image
        newHazard.setValue(h.hazardImpact, forKey: "impact")
        newHazard.setValue(0, forKey: "is_sync")
        newHazard.setValue(h.location, forKey: "location")
        newHazard.setValue(hazardName.text, forKey: "name")
        newHazard.setValue(txtTime.text, forKey: "time")
        newHazard.setValue(h.hazardImpact2, forKey: "type")
        newHazard.setValue(userId, forKey: "user_id") //get value from shared preference
        
        //get sign in of user login
        
        print("======Hazard to saved!====")
        print("company: \(h.company)")
        print("date: \(h.date)")
        print("dept: \(h.department)")
        print("description: \(h.hazardDescription)")
        print("image: \(image)")
        print("subdomain: \(subdomain)")
        print("hazard type: \(h.hazardType)")
        print("impact: \(h.hazardImpact)")
        print("type: \(h.hazardImpact2) ")
        print("user_id: \(userId)")
        
        
        
        
        /*
         redo later
        
        do {
            try context.save()
        } catch _ {
        } */
        
        print("Saved => \(newHazard)")

        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle;
        
        
        
        
        let postString = "date=\(formatter.stringFromDate(formatter.dateFromString(h.date)!))&description=\(hazardDescription.text)&hazard_type=\(h.hazardType)&hazard_impact=\(h.hazardImpact)&company=\(h.company)&department=\(h.department)&location=\(h.location)&type_add=\(h.hazardImpact2)&name=\(hazardName.text)&user_id=\(userId)&image_attachment=\(imageAtt)&username=\(username)&password=\(password)"
        

        
        let request = NSMutableURLRequest(URL:NSURL(string:"https://\(subdomain).ehss.net/mobile/save_hazard")!)
        let session = NSURLSession.sharedSession()
       
        
        request.HTTPMethod = "POST"
        
        let hazardN:String = hazardName.text! as String
        
        let params = ["date":"\(formatter.stringFromDate(formatter.dateFromString(h.date)!))","description":"\(hazardDescription.text!)","hazard_type":"\(h.hazardType)","hazard_impact":"\(h.hazardImpact)","company":"\(h.company)","department":"\(h.department)","location":"\(h.location)","type_add":"\(h.hazardImpact2)","name":"\(hazardN)","user_id":"\(userId)","image_attachment":"\(imageAtt)","username":"\(username)","password":"\(password)"] as Dictionary<String, String>
        
        let paramLength = "\(postString.characters.count)"
        
        //let err:NSError?
        
        do{
       
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
        request.addValue(paramLength, forHTTPHeaderField: "Content-Length")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        }catch{
        
        }

        
        let task = session.dataTaskWithRequest(request){
            data, response, error -> Void in
            
            do{
            
            let strData = NSString(data:data!, encoding:NSUTF8StringEncoding)
            print("Body\(strData)");
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)", terminator: "")
                print("response = \(response)", terminator: "")
            }
            
       
                //let err: NSError?
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                
                
                /*if err != nil {
                    print(err!.localizedDescription)
                    let jsonStr = NSString(data:data!, encoding:NSUTF8StringEncoding)
                    print("Error could not parse json: \(jsonStr)")
                }else{ */
                    if let parseJSON = json{
                        let success = parseJSON["save"] as? Int
                        print("Success \(success)")
                    }else{
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Error could not parse JSON: \(jsonStr)")
                    }
                //}
            
            
            
          
            }catch{
            
            }
  
            
           
        }
        
        //task.resume()
        
        clearForm()
        
        //redirect to list
      
    }
    
    func clearForm(){
        
        txtDate.text = ""
        txtLocation.text = ""
        txtCompany.text = ""
        txtDept.text = ""
        txtHazardType.text = ""
        txtHazardImpact.text = ""
        txtHazardImpact2.text = ""
        hazardDescription.text = ""
        hazardName.text = ""
        txtTime.text = "" //set as current date
    
    }
    
    func getUserId(let val:String) ->Int{
        var id:Int = 0;
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "User")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "email = %@", val)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            
            id = res.valueForKey("user_id") as! Int
        }
        
        print("User Id to pass: \(id)")
        return 2
    }
    
    func getLocation(let val:String) ->Int {
        
        
        var id:Int = 0
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Location")

        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name = %@",val)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("Error finding location", terminator: "")
        }
        
        return id
    }
    
    func getCompany(let val:String) -> Int{
        var id:Int = 0
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Milestone")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "company = %@",val)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("Error find company", terminator: "")
        }
        return id
    
    }
    
    func getDepartment(let val:String) -> Int{
        var id:Int = 0
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Unit")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name = %@", val)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("Error finding department id", terminator: "")
        }
        
        return id
    
    }
    
    func getHazardType(let val:String) -> Int{
        var id:Int = 0
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Preferences")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "preference = %@", val)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("Error finding hazard type", terminator: "")
        }
        
        return id
        
    }
    
    
    func getHazardImpact(let val:String)->Int{
        var id:Int = 0
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "HazardOrigin")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "origin = %@", val)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("error finding hazard impact!", terminator: "")
        }
        
        
        return id
    
    }

}


