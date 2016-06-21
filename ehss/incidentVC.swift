//
//  incidentVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/3/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

class incidentVC: UIViewController,UITextFieldDelegate {
    
    var popDatePicker : PopDatePicker?
    var popLocationPicker : PopLocationPicker?
    var popDepartmentPicker : PopDeptPicker?
    var popCompanyPicker : PopCompanyPicker?
    
    var userPref = NSUserDefaults()
    
    

    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtDepartment: UITextField!
    @IBOutlet weak var txtActivity: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtNature: UITextField!
    
    var nat = ""
    
    
    struct Incident {
        var date: String
        var time: String
        var location: Int
        var company: Int
        var department: Int
        var activity: String
        var description: String
        var userId:Int
        var user:String
        var password: String
        var nature:Int
        var nature_category: Int
        var image: String
    }
    
    var incident:Incident = Incident(date: "", time: "", location: 0, company: 0, department: 0, activity: "", description: "", userId: 0, user: "", password: "", nature: 0, nature_category: 0, image:"")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popDatePicker = PopDatePicker(forTextField: txtDate)
        txtDate.delegate = self
        
        popLocationPicker = PopLocationPicker(forTextField: txtLocation)
        txtLocation.delegate = self
        
        popDepartmentPicker = PopDeptPicker(forTextField: txtDepartment)
        txtDepartment.delegate = self
        
        popCompanyPicker = PopCompanyPicker(forTextField: txtCompany)
        txtCompany.delegate = self
        
        
        txtNature.text = nat
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLoadNature(sender: UIButton) {
       // let username = ""
        //let password = ""
        
    //    let inc = Incident(date: txtDate.text!, time: txtTime.text!, location: getLocation(txtLocation.text!), company: getCompany(txtCompany.text!), department: getDepartment(txtDepartment.text!), activity: txtActivity.text!, description: txtDescription.text!, userId: 2, user: username, password: password,nature: 0, nature_category:0, image:"")
        
        
    }
    
    
    
    @IBAction func btnNext(sender: UIButton) {
        //println("Incident has been recorded:\(incident.description)")
        
        print("inside save!")
        
        var username = ""
        var password = ""
      
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let newIncident = NSEntityDescription.insertNewObjectForEntityForName("Noi", inManagedObjectContext: context) 
        
        
        var userId:Int = 0
        //let imageAtt:String = ""
        var subdomain:String = ""
        
        if userPref.valueForKey("ehss_username") != nil  && userPref.valueForKey("ehss_password") != nil && userPref.valueForKey("subdomain") != nil {
            username = userPref.valueForKey("ehss_username") as! String
            password = userPref.valueForKey("ehss_password") as! String
            subdomain = userPref.valueForKey("subdomain") as! String
            userId = 2
        }
        
        //get value of nature here
        let getNatureVar = getNatureIds(txtNature.text! as String)
        newIncident.setValue(incident.department, forKey: "department")
        newIncident.setValue(incident.description, forKey: "desc")
        newIncident.setValue(getNatureVar.0, forKey:"nature")
        newIncident.setValue(getNatureVar.1, forKey: "nature_category")
        newIncident.setValue(txtTime.text! as String, forKey: "time") //get from shared preference
        
        newIncident.setValue(incident.date, forKey: "date")
        newIncident.setValue(incident.location, forKey: "location") // load camera image
        newIncident.setValue(txtDescription.text! as String, forKey: "desc")
        newIncident.setValue(txtActivity.text! as String, forKey: "activity")
        newIncident.setValue(userId, forKey: "user_id")
        newIncident.setValue(incident.company, forKey: "company_id")
        newIncident.setValue(incident.image, forKey: "image")
        //newIncident.setValue(username, forKey: "username")
        //newIncident.setValue(password, forKey: "password")
        
        
        
        
        print("=====Nature Value:=====")
        print("department: \(incident.department)")
        //println("description: \(incident.description)")
        print("nature: \(getNatureVar.0)") // nature id
        print("nature_category: \(getNatureVar.1)")
        print("time: \(txtTime.text! as String)")
        print("date: \(incident.date)")
        print("location: \(incident.location)")
        print("description: \(txtDescription.text! as String)")
        print("activity: \(txtActivity.text! as String)")
        print("user_id: \(userId)")
        print("company_id: \(incident.company)")
        print("image: \(incident.image)")
        print("username: \(username)")
        print("password: \(password)")
        
        
        do {
            try context.save()
        } catch _ {
        }
        
        //mobile/save_noi
        //is_save == 1
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle;
        
        let request = NSMutableURLRequest(URL:NSURL(string:"https://\(subdomain).ehss.net/mobile/save_noi")!)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = "POST"
        
        let params = [
            "department":"\(incident.department)",
            "description":"\(txtDescription.text! as String)",
            "nature":"\(getNatureVar.0)",
            "nature_category":"\(getNatureVar.1)",
            "time":"\(txtTime.text! as String)",
            "date":"\(formatter.stringFromDate(formatter.dateFromString(incident.date)!))",
            "location":"\(incident.location)",
            "activity":"\(txtActivity.text! as String)",
            "user_id":String(userId),
            "company_id":"\(incident.company)",
            "image":"\(incident.image)",
            "username":"\(username)",
            "password":"\(password)"
            
            ] as Dictionary<String, String>
        
        
        let paramLength = "\(params.count)"
        do {
        //let err:NSError?
        
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
        } catch{
            //err = error
            request.HTTPBody = nil
        }
        request.addValue(paramLength, forHTTPHeaderField: "Content-Length")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let task = session.dataTaskWithRequest(request){
            data, response, error -> Void in
        
            let strData = NSString(data:data!, encoding:NSUTF8StringEncoding)
                print("Body\(strData)");
        
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)", terminator: "")
                print("response = \(response)", terminator: "")
            }
            
            
            do{
        
            //let err: NSError?
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                
                if let parseJSON = json{
                    let success = parseJSON["is_save"] as? Int
                    
                    if success == 1 {
                        print("Incident successfully submitted")
                    }
                    
                    print("Success \(success)")
                }else{
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: \(jsonStr)")
                }

                
            }catch{
                //print(err!.localizedDescription)
                let jsonStr = NSString(data:data!, encoding:NSUTF8StringEncoding)
                print("Error could not parse json: \(jsonStr)")
            }
        
            
            
            print("Incident succesfully execute!")
        
        }
        
        task.resume()
        
    }
    
    func resign(){
        txtDate.resignFirstResponder()
        txtLocation.resignFirstResponder()
        txtDepartment.resignFirstResponder()
        txtCompany.resignFirstResponder()
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField)->Bool{
        if(textField === txtDate){
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = formatter.dateFromString(txtDate.text!)
            
            let dataChangedCallback:PopDatePicker.PopDatePickerCallback = {
                (newDate: NSDate, forTextField: UITextField)->() in
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
                self.incident.date = self.txtDate.text! as String
            }
            
            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            return false
        }else if(textField === txtDepartment){
            resign()
            
            let initDept:NSString? = txtDepartment.text
            let dataChangedCallback : PopDeptPicker.PopDeptPickerCallback = {
                ( newVal: NSString, forTextField: UITextField ) -> () in
                forTextField.text = "\(newVal)"
                self.incident.department = self.getDepartment(self.txtDepartment.text! as String)
                
            }
            
            let companyIdVal:Int? = self.getCompany(txtCompany.text! as String)
            
            popDepartmentPicker!.pick(self, initDate: initDept, dataChanged: dataChangedCallback, company:companyIdVal!)
            
            return false;

        }else if(textField === txtCompany){
            resign()
            let initCompany: NSString? = txtCompany.text
            
            let dataChangedCallback : PopCompanyPicker.PopCompanyPickerCallback = {
                ( newCompany: NSString, newVal : NSInteger,  forTextField: UITextField) -> () in
                
                forTextField.text = "\(newCompany)"
                
                
                self.txtDepartment.text = ""
                self.incident.company = self.getCompany(self.txtCompany.text! as String)
            }
            
                popCompanyPicker!.pick(self, initDate:initCompany, dataChanged: dataChangedCallback)
            
            
            return false;

        
        }else if(textField === txtLocation){
            resign()
            
            let initLocation:NSString? = txtLocation.text
            let dataChangedCallback: PopLocationPicker.PopLocationPickerCallback = {
                (newVal:NSString, forTextField:UITextField) -> () in
                forTextField.text = "\(newVal)"
                
                self.incident.location = self.getLocation(self.txtLocation.text!)
            }
            
            popLocationPicker!.pick(self, initDate: initLocation, dataChanged: dataChangedCallback)
            
            return false
        
        }else{
            return true;
        }
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
    
    func getNatureIds(let value: String) -> (Int, Int){
        var id:Int = 0
        var category_id:Int = 0
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Nature")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "nature = %@", value)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            
            let res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
            category_id = res.valueForKey("category_id") as! Int
            
        }else{
            print("Error finding department id", terminator: "")
        }

        
        return (id,category_id)
    }
    

}
