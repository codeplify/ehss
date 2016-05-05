import UIKit
import CoreData

class hazardVC: UIViewController,UITextFieldDelegate {
    
    var popDatePicker : PopDatePicker?
    var popCompanyPicker: PopCompanyPicker?
    var popDeptPicker: PopDeptPicker?
    var popLocationPicker: PopLocationPicker?
    var popHazardTypePicker: PopHazardTypePicker?
    var popHazardImpactPicker: PopHazardTypePicker?
    var popHazardImpactPicker2: PopHazardTypePicker?
    var popTimePicker: PopDatePicker?
    
    var userPref = NSUserDefaults.standardUserDefaults()
    
    
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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if (textField === txtDate) {
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = formatter.dateFromString(txtDate.text)
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
                
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
                
                self.hazardObject.date = self.txtDate.text as String
                print("Hazard object value: \(self.hazardObject.date)")
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
            
            let companyIdVal:Int? = self.getCompany(txtCompany.text as String)
            
            
        
            popDeptPicker!.pick(self, initDate: initDept, dataChanged: dataChangedCallback, company:companyIdVal!)
            
            return false;
            
        }else if (textField === txtLocation){
            resign()
            
            let initLocation:NSString? = txtLocation.text
            let dataChangedCallback: PopLocationPicker.PopLocationPickerCallback = {
                (newVal:NSString, forTextField:UITextField) -> () in
                forTextField.text = "\(newVal)"
                
                self.hazardObject.location = self.getLocation("\(newVal)")
                
                print("Location \(self.hazardObject.location)");
                
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
            
            var dataString = txtHazardImpact.text as String
            
            //print("data string value: \(dataString)")
            
            popHazardImpactPicker2!.pick(self, initDate: initHazardTypeImpact2, dataChanged: dataChangedCallback, dataHazard: 2, dataId:dataString)
            
            return false;
        }else {
            return true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func openDate(sender: UIButton) {
        
    }
    
    @IBAction func btnSubmitHazard(sender: UIButton) {
       
        
        if validateHazard() {
            println("Date: \(hazardObject.date)")
            //println("Time: \(hazardObject.time)")
            println("Company: \(hazardObject.company)")
            println("Location: \(hazardObject.location)")
            println("Department: \(hazardObject.department)")
            println("Hazard Type: \(hazardObject.hazardType)")
            println("Hazard Impact: \(hazardObject.hazardImpact)")
            println("Hazard Impact 2:\(hazardObject.hazardImpact2)")
            println("Hazard Name: \(hazardNameText.text)")
            println("Hazard Description:  \(hazardDescText.text)")
            
            
            hazardSave(hazardObject)
            
            
        }else{
             println(" fill out all of the data")
        }
        
        
        
    }
    
    func validateHazard() -> Bool{
        
        var validated = true;
        
        if txtDate.text == ""{
            println("Date is empty")
            validated = false
            return validated;
        }
        
        if txtTime.text == "" {
            //validated = false
            println("Time is empty")
             return validated;
        }
        
        if txtCompany.text == "" {
            println("Company is empty")
            validated = false
             return validated;
        }
        
        if txtLocation.text == "" {
            println("Department is empty")
            validated = false
             return validated;
        }
        
        if txtHazardType.text == "" {
            println("Hazard Type is empty")
            validated = false
             return validated;
        }
        
        if txtHazardImpact.text == "" {
            println("Hazard impact is empty")
            validated = false
             return validated;
        }
        
        if txtHazardImpact2.text == "" {
            println("Hazard impact 2 is empty")
            validated = false
             return validated;
        }
        
        if hazardName.text == "" {
            println("Hazard name is empty")
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
        
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = AppDel.managedObjectContext!
        var newHazard = NSEntityDescription.insertNewObjectForEntityForName("Hazard", inManagedObjectContext: context) as! NSManagedObject
        
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
        
        
        context.save(nil)
        
        println("Saved => \(newHazard)")

        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle;
        
        
     
 

        
        var postString = "date=\(formatter.stringFromDate(formatter.dateFromString(h.date)!))&description=\(hazardDescription.text)&hazard_type=\(h.hazardType)&hazard_impact=\(h.hazardImpact)&company=\(h.company)&department=\(h.department)&location=\(h.location)&type_add=\(h.hazardImpact2)&name=\(hazardName.text)&user_id=\(userId)&image_attachment=\(imageAtt)&username=\(username)&password=\(password)"
        

        
        var request = NSMutableURLRequest(URL:NSURL(string:"https://\(subdomain).ehss.net/mobile/save_hazard")!)
        var session = NSURLSession.sharedSession()
       
        
        request.HTTPMethod = "POST"
        
        var params = ["date":"\(formatter.stringFromDate(formatter.dateFromString(h.date)!))","description":"\(hazardDescription.text)","hazard_type":"\(h.hazardType)","hazard_impact":"\(h.hazardImpact)","company":"\(h.company)","department":"\(h.department)","location":"\(h.location)","type_add":"\(h.hazardImpact2)","name":"\(hazardName.text)","user_id":"\(userId)","image_attachment":"\(imageAtt)","username":"\(username)","password":"\(password)"] as Dictionary<String, String>
        
        var paramLength = "\(count(postString))"
        
        var err:NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue(paramLength, forHTTPHeaderField: "Content-Length")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        

        
        var task = session.dataTaskWithRequest(request){
            data, response, error -> Void in
            
            var strData = NSString(data:data, encoding:NSUTF8StringEncoding)
            println("Body\(strData)");
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            if err != nil {
                println(err!.localizedDescription)
                let jsonStr = NSString(data:data, encoding:NSUTF8StringEncoding)
                println("Error could not parse json: \(jsonStr)")
            }else{
                if let parseJSON = json{
                    var success = parseJSON["save"] as? Int
                    println("Success \(success)")
                }else{
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
            
           
        }
        
        task.resume()
        
        clearForm()
        
        
      
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
    
    func getUserId(var val:String) ->Int{
        var id:Int = 0;
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = AppDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "User")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "email = %@", val)
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            var res = results[0] as! NSManagedObject
            
            id = res.valueForKey("user_id") as! Int
        }
        
        println("User Id to pass: \(id)")
        return 2
    }
    
    func getLocation(var val:String) ->Int {
        
        
        var id:Int = 0
        
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = AppDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Location")

        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name = %@",val)
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            var res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("Error finding location")
        }
        
        return id
    }
    
    func getCompany(var val:String) -> Int{
        var id:Int = 0
        
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = AppDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Milestone")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "company = %@",val)
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            var res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("Error find company")
        }
        return id
    
    }
    
    func getDepartment(var val:String) -> Int{
        var id:Int = 0
        
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = AppDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Unit")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name = %@", val)
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            var res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("Error finding department id")
        }
        
        return id
    
    }
    
    func getHazardType(var val:String) -> Int{
        var id:Int = 0
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = AppDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Preferences")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "preference = %@", val)
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            var res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("Error finding hazard type")
        }
        
        return id
        
    }
    
    
    func getHazardImpact(var val:String)->Int{
        var id:Int = 0
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = AppDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "HazardOrigin")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "origin = %@", val)
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            var res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("error finding hazard impact!")
        }
        
        
        return id
    
    }

}


