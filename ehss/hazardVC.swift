import UIKit
import CoreData



class hazardVC: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    // MARK:- Property Delegates Declaration
    
    let imgPicker = UIImagePickerController()
    
    var hazard:Hazard?
    var hazardId:Int = 0
    var popDatePicker : PopDatePicker?
    var popCompanyPicker: PopCompanyPicker?
    var popDeptPicker: PopDeptPicker?
    var popLocationPicker: PopLocationPicker?
    var popHazardTypePicker: PopHazardTypePicker?
    var popHazardImpactPicker: PopHazardTypePicker?
    var popHazardImpactPicker2: PopHazardTypePicker?
    var popTimePicker: PopDatePicker?
    @IBOutlet weak var imgAttachment: UIImageView!
    var userPref = NSUserDefaults.standardUserDefaults()
    
    
    // MARK:- UIView Declaration
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
    @IBOutlet weak var btnSubmitForLabel: UIButton!
    
    var activeField: UITextField?
    @IBOutlet weak var lblUserFull: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnAttachment: UIButton!
    
    
    
    // MARK:- Capture Image using Camera
    
    @IBAction func captureImage(sender: AnyObject) {
        
            imgPicker.allowsEditing = false
            imgPicker.sourceType = UIImagePickerControllerSourceType.Camera
            imgPicker.cameraCaptureMode = .Photo
            imgPicker.modalPresentationStyle = .FullScreen
            presentViewController(imgPicker, animated: true, completion: nil)
        
    }
    
    // MARK:- Select Image Attachment
    
    @IBAction func btnAttached(sender: UIButton) {
        
       /* imgPicker.allowsEditing = false
        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        imgPicker.modalPresentationStyle = .Popover
        presentViewController(imgPicker, animated: true, completion: nil) */
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)

    }
    
    // MARK: Image Picker Delegates 1
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Image Picker Delegates 2
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imgAttachment.contentMode = .ScaleAspectFit
        imgAttachment.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
// MARK:- Hazard Struct Declaration
    
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
    

// MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coreUtil = CoreDataUtility()
        
        imgPicker.delegate = self
        
        txtTime.text = "\(currentTime())"
        txtDate.text = "\(currentDate())"
        
        if hazardId > 0 {
            
            //Alert.show("Hazard", message: "Load Hazard", vc: self)
            
            let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            
            let context:NSManagedObjectContext = AppDel.managedObjectContext!
            let request = NSFetchRequest(entityName: "Hazard")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "id = %@", "\(hazardId)")
            
            
            btnSubmitForLabel.setTitle("Update", forState: UIControlState.Normal)
            
            do{
                let result:NSArray = try context.executeFetchRequest(request)
                
                if result.count > 0 {
                    
                    let description = result[0].valueForKey("desc") as! String
                    let company_id = result[0].valueForKey("company_id") as! Int
                    let department = result[0].valueForKey("department") as! Int
                    let date = result[0].valueForKey("date") as! String
                    let hazard_type = result[0].valueForKey("hazard_type") as! Int
                    let id = result[0].valueForKey("id") as! Int
                    let impact = result[0].valueForKey("impact") as! Int
                    let is_sync = result[0].valueForKey("is_sync") as! Int
                    let location = result[0].valueForKey("location") as! Int
                    let name = result[0].valueForKey("name") as! String
                    let type = result[0].valueForKey("type") as! Int
                    let user_id = result[0].valueForKey("user_id") as! Int
                    
                    
                    hazardDescription.text = description
                    txtCompany.text = CoreDataUtility.getCompany(company_id)
                    txtDept.text = CoreDataUtility.getDepartment(department)
                    txtDate.text = "\(date)"
                    txtHazardType.text = CoreDataUtility.getHazardType(hazard_type)
                    txtHazardImpact.text = CoreDataUtility.getHazardImpact(impact)
                    txtLocation.text = CoreDataUtility.getLocation(location)
                    hazardName.text = "\(name)"
                    txtHazardImpact2.text = CoreDataUtility.getHazardImpact(type)
                    
                    
                    //Singleton
                    
                    let coreData = CoreDataUtility.sharedInstance
                    
                    
                    if CoreDataUtility.isSync(hazardId, entity: "Hazard", comparator: "id") {
                        
                        hazardDescription.enabled = false
                        txtCompany.enabled = false
                        txtDept.enabled = false
                        txtDate.enabled = false
                        txtHazardType.enabled = false
                        txtHazardImpact.enabled = false
                        txtHazardImpact2.enabled = false
                        txtLocation.enabled = false
                        hazardName.enabled = false
                        
                        
                        /*
                         
                        var hazard:Hazard = Hazard()
                        
                        hazard.hazardDescription = description
                        hazard.company = company_id
                        hazard.department = department
                        hazard.date = date
                        hazard.hazardType = hazard_type
                        hazard.hazardImpact = impact
                        hazard.location = location
                        hazard.hazardName = name
                        hazard.hazardImpact2 = type
                        
                         */
                        
                    }
                    
                }
                
                
            }catch {
                
            }
            
        }
        
        
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
        }else{
            //redirect here to dashboard
            print("reveal view controller doesnt exist!")
        }
        
        //hazardName.delegate = self
        //hazardDescription.delegate = self
        
    }
    

    
    var kbHeight:CGFloat!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        
    }


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
            
            
            if btnSubmitForLabel.currentTitle == "Update" {
                
                Alert.show("Update", message: "Update this hazard", vc: self)
                
                
            }else{
                hazardSave(hazardObject)
            }
            
            
            
        }else{
             print(" fill out all of the data")
        }
        
        
        
    }
    
    // MARK:- Data Validation
    
    func validateHazard() -> Bool{
        
        var validated = true;
        
        if txtDate.text == ""{
            
            Alert.show("Error", message: "Date is empty", vc: self)
            
            
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
    
}

// MARK:- SAVE to SQLite

extension hazardVC{

    
    // MARK: Save Main Function
    func hazardSave(var h:Hazard){
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let newHazard = NSEntityDescription.insertNewObjectForEntityForName("Hazard", inManagedObjectContext: context)
        
        //convert integer value to string
        
        
        
        var userId:Int = 0
        var imageAtt:String = ""
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
        
        /*
         let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.fromRaw(0)!)
         println(base64String)
         
         */
        
        let imageData = UIImageJPEGRepresentation(imgAttachment.image!, 0.5)
        
        let base64String = imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        //newHazard.setValue(newHazard.objectID, forKey: "id")
        newHazard.setValue(CoreDataUtility.getIncrementedId("Hazard"), forKey: "id")
        newHazard.setValue(h.company, forKey: "company_id")
        newHazard.setValue(h.date, forKey: "date")
        newHazard.setValue(h.department, forKey: "department")
        newHazard.setValue(hazardDescription.text, forKey: "desc")
        newHazard.setValue(subdomain, forKey: "domain") //get from shared preference
        newHazard.setValue(h.hazardType, forKey: "hazard_type")
        //newHazard.setValue(, forKey: "id") // default or autocreate
        newHazard.setValue(base64String, forKey: "image") // load camera image
        newHazard.setValue(h.hazardImpact, forKey: "impact")
        newHazard.setValue(h.location, forKey: "location")
        newHazard.setValue(hazardName.text, forKey: "name")
        newHazard.setValue(txtTime.text, forKey: "time")
        newHazard.setValue(h.hazardImpact2, forKey: "type")
        newHazard.setValue(userId, forKey: "user_id")
        newHazard.setValue(1, forKey: "is_sync")
        
       
        
        
        
        
        
        
        
        
        //get value from shared preference
        
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
        print("===========save local ends")
        
        
        
        
        
        // redo later
        
        do {
            try context.save()
        } catch _ {
        }
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle;
        
        
        h.date = formatter.stringFromDate(formatter.dateFromString(h.date)!)
        h.hazardName = (hazardName.text! as String)
        h.hazardDescription = (hazardDescription.text! as String)
        
        multipartFormRequest(h)
        
        //print("Saved => \(newHazard)")
        
        
        
        imageAtt = base64String!
        
        //print("base64 - \(base64String)")
        
        let postString = "date=\(formatter.stringFromDate(formatter.dateFromString(h.date)!))&description=\(hazardDescription.text)&hazard_type=\(h.hazardType)&hazard_impact=\(h.hazardImpact)&company=\(h.company)&department=\(h.department)&location=\(h.location)&type_add=\(h.hazardImpact2)&name=\(hazardName.text)&user_id=\(userId)&image_attachment=\(imageAtt)&username=\(username)&password=\(password)"
        
        let request = NSMutableURLRequest(URL:NSURL(string:"https://\(subdomain).ehss.net/mobile/save_hazard")!)
        let session = NSURLSession.sharedSession()
        
        
        request.HTTPMethod = "POST"
        
        let hazardN:String = hazardName.text! as String
        let hazardD:String = hazardDescription.text! as String
        
        let params = [
            "date":"\(formatter.stringFromDate(formatter.dateFromString(h.date)!))",
            "description":"\(hazardD)",
            "hazard_type":"\(h.hazardType)",
            "hazard_impact":"\(h.hazardImpact)",
            "company":"\(h.company)",
            "department":"\(h.department)",
            "location":"\(h.location)",
            "type_add":"\(h.hazardImpact2)",
            "name":"\(hazardN)",
            "user_id":"\(userId)",
            "image_attachment":"\(imageAtt)",
            "username":"\(username)",
            "password":"\(password)"
            ] as Dictionary<String, String>
        
        
        for(key, value) in params{
            //print("params value => \(key): \(value)")
        }
        
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
                //print("Body\(strData)");
                
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
        
        clearForm()
        
        //task.resume()
        //redirect to list
        
    }
    
    
    //MARK: Clear Form after submitted
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
        
        //redirect to
        
    }

}



// MARK:- Textfield Extension Functions

extension hazardVC{
    
    
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


}

// MARK:- Navigation Code extention
extension hazardVC{
    // MARK: Navigation Reveal Toggle
    
    @IBAction func revealCall(sender: AnyObject) {
        if self.revealViewController() != nil {
            btnListAll.target = self.revealViewController()
            btnListAll.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }else{
            print("reveal view controller doesnt exist!")
            
            //self.performSegueWithIdentifier("toDashboard2", sender: self)
        }
        print("reveal is call")
    }

}




// MARK:- hazard Update extenstions

extension hazardVC{
    
    
    // MARK:- Retrive Hazard
    func getHazard(let id:Int) -> Hazard{
        
        
        var hazard:Hazard = Hazard(time: "", date: "", company: 0, department: 0, location: 0, hazardType: 0, hazardImpact: 0, hazardImpact2: 0, hazardName: "", hazardDescription: "")
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Hazard")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do{
            let result:NSArray = try context.executeFetchRequest(request)
            
            if result.count > 0 {
                
                let description = result[0].valueForKey("desc") as! String
                
                hazard.hazardDescription = description
                
            }
            
            
        }catch {
            
        }
        
        
        return hazard
        
    }

}




// MARK:- Network Process Extenstions

extension hazardVC{
    
    // MARK:- Generate Body Files to send to server
    func createBodyWithParameters(parameters:[String:String]?, filePathKey:String?, imageDataKey:NSData , boundary:String)->NSData{
        
        let body = NSMutableData()
        let filename = "sentimage.jpg"
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Copy-Disposition:form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type:\(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        print("--\(boundary)\r\n")
        print("Copy-Disposition:form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
        print("Content-Type:\(mimetype)\r\n\r\n")
        print(imageDataKey)
        print("\r\n")
        
        
        if parameters != nil {
            for(key, value) in parameters!{
                
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
                
                print("--\(boundary)\r\n")
                print("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                print("\(value)\r\n")
                
            }
        }
        
        body.appendString("--\(boundary)\r\n")
        print("--\(boundary)\r\n")
        
        return body
    }
    
    // MARK: Generate the Request to  Server
    func multipartFormRequest(hazard: Hazard){
        
        let cutil:CommonUtils = CommonUtils.sharedInstance
        
        let myURL = NSURL(string: "https://\(cutil.getDomain()).ehss.net/mobile/save_hazard2")
        let request = NSMutableURLRequest(URL: myURL!)
        request.HTTPMethod = "POST"
        
        
        /*
         $date = Helper::formatDisplayDate($input->date);
         $description = $input->description;
         $type = $input->hazard_type;
         $impact = $input->hazard_impact;
         $company = $input->company;
         $department = $input->department;
         $location = $input->location;
         $type_add = $input->type_add;
         $hazard_name = $input->name;
         $hazard_code = uniqid();
         $username = $input->username;
         $password = $input->password;
         */
        
        /*
         
         let params = [
         "date":"\(formatter.stringFromDate(formatter.dateFromString(h.date)!))",
         "description":"\(hazardD)",
         "hazard_type":"\(h.hazardType)",
         "hazard_impact":"\(h.hazardImpact)",
         "company":"\(h.company)",
         "department":"\(h.department)",
         "location":"\(h.location)",
         "type_add":"\(h.hazardImpact2)",
         "name":"\(hazardN)",
         "user_id":"\(userId)",
         "image_attachment":"\(imageAtt)",
         "username":"\(username)",
         "password":"\(password)"
         ] as Dictionary<String, String>
         
         
         for(key, value) in params{
         print("params value => \(key): \(value)")
         }
         */
        
        
        
        
        let param = [
            "date":"\(hazard.date)",
            "description":"\(hazard.hazardDescription)",
            "hazard_type":"\(hazard.hazardImpact)",
            "hazard_impact":"\(hazard.company)",
            "company":"\(hazard.department)",
            "department":"\(hazard.department)",
            "location":"\(hazard.location)",
            "type_add":"\(hazard.hazardImpact2)",
            "name":"\(hazard.hazardName)",
            "username":"\(cutil.emailAddress())",
            "password":"\(cutil.currentPassword())"
        ]
        
        print("==========start parsing==============")
        print("\(myURL)")
        for(key, value ) in param{
            print("\(key):\(value)")
        }
        print("=========end of data parsing============")
        
        
        let boundary = generateBoundaryString()
        let img:UIImage = imgAttachment.image!
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = UIImageJPEGRepresentation(img, 0.5)
        if imageData == nil {return;}
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
        {
            data, response, error in
            
            if error != nil {
                print("error = \(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            print("Response=> \(responseString)")
        }
        
        task.resume()
        
        
    }
    
    // MARK: Generate Boundary String
    func generateBoundaryString()->String{
        return "Boundary-\(NSUUID().UUIDString)"
    }

}


// MARK:- Utility Functions Extentions

extension hazardVC{
    
    // MARK: Retrieve Company ID
    
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
    
    // MARK: Retrieve User ID
    
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
    
    // MARK: Retrieve Location ID
    
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
    
    // MARK: Retrieve Department ID
    
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
    
    // MARK: Retrieve Hazard Type
    
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
    
    // MARK: Retrieve Hazard Impact
    
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
    
    // MARK: Function Utility get current date
    
    func currentDate()->String{
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        return "\(dateFormatter.stringFromDate(date))"
    }
    
    // MARK: Function get current time
    
    func currentTime() -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .MediumStyle
        
        return "\(dateFormatter.stringFromDate(date))"
    }

}


// MARK:- Mutable Data Extension

extension NSMutableData{
    func appendString(string: String){
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }

}







