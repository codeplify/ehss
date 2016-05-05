//
//  loginVC.swift
//  ehss
//
//  Created by IOS1-PC on 3/18/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

class loginVC: UIViewController {
    
    
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let alert = UIAlertView()
    
    var username = ""
    var password = ""
    var s = ""
    
    var urlLoadMilestone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func loadUnitString(subd: String, uname: String, pword: String) -> String{
        return "https://\(subd).ehss.net/mobile/get_unit/username/\(uname)/password/\(pword)"
    }
    
    static func loadPreferencesString(subd: String, uname: String, pword:String) -> String{
        return "https://\(subd).ehss.net/mobile/getpreferences/username/\(uname)/password/\(pword)"
    }
    
    static func loadLocationString(subd: String, uname: String, pword: String) -> String{
        return "https://\(subd).ehss.net/mobile/getmap2/username/\(uname)/password/\(pword)"
    }
    
    static func loadHazardOriginString(subd: String, uname: String, pword: String) -> String{
        return "https://\(subd).ehss.net/mobile/get_hazard_origin"
    }
    
    static func loadNatureString(subd: String, uname:String, pword: String)->String{
        return "https://\(subd).ehss.net/mobile/get_nature"
    }


    @IBAction func btnLogin(sender: UIButton) {
        
        
        let status = Reach.connectionStatus()
        switch status {
            case .Unknown, .Offline:
                println("Not Connected")
            case .Online(.WWAN):
                println("Connected via WWAN")
            case .Online(.WiFi):
                println("Connected via WiFi")
            
        
        
        username = txtUsername.text
        password = txtPassword.text
        
        var urlLogin = "https://www.ehss.net/mobile/mobile_login?username=\(username)&password=\(password)"
        
        urlLoadMilestone = "https://test.ehss.net/mobile/milestone/username/\(username)/password/\(password)"
        
        
        
        
        let requestURL:NSURL = NSURL(string: urlLogin)!
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
                
        let task = session.dataTaskWithRequest(urlRequest){
            (data,response,error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if(statusCode==200){
                
                let json = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: nil) as! [String:AnyObject]
                
                
                if let retrieve = json["retrieve"] as? String{
                    
                    
                    if retrieve == "failed" {
                        
                        self.alert.title = "Error Message"
                        self.alert.message = "Invalid Username/Password"
                        self.alert.addButtonWithTitle("Ok")
                        self.alert.show()
                        
                        println("Error logging in to Ehss.net")
                        
                    }

                    
                    if let subdomain = json["subdomain"] as? String{
                        
                        
                        self.s = subdomain
                        
                        if retrieve == "success" {
                            println("successfully login")
                            
                            self.userDefaults.setValue(self.username ,forKey: "ehss_username")
                            self.userDefaults.setValue(self.password, forKey: "ehss_password")
                            
                            self.userDefaults.setValue(subdomain, forKey: "subdomain")
                            
                            self.loadUnit(loginVC.loadUnitString(subdomain, uname: self.username, pword: self.password))
                            self.loadPreferences(loginVC.loadPreferencesString(subdomain, uname: self.username, pword: self.password))
                            self.loadLocation(loginVC.loadLocationString(subdomain, uname: self.username, pword: self.password))
                            self.loadHazardOrigin(loginVC.loadHazardOriginString(subdomain, uname: self.username, pword: self.password))
                            self.loadNature(loginVC.loadNatureString(subdomain, uname: self.username, pword: self.password))
                            
                            /*
                                Save here the user controller value in CoreData
                            */
                            
                            var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                            
                            var context:NSManagedObjectContext = AppDel.managedObjectContext!
                            
                            var newUserController = NSEntityDescription.insertNewObjectForEntityForName("Usercontroller", inManagedObjectContext: context) as! NSManagedObject
                            
                            newUserController.setValue(1, forKey: "id")
                            newUserController.setValue(subdomain, forKey: "subdomain")
                            
                            context.save(nil)
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                            println("Usercontroller created! \(newUserController)")
                            
                        }
                        
                    }
                }
                
                
                //println(json)
                
                
                self.loadMilestone(self.urlLoadMilestone)
                
            }else{
                self.alert.title = "Error Message"
                self.alert.message = "No internet connection detected."
                self.alert.addButtonWithTitle("Ok")
                self.alert.show()
            }
            
        }
        
        
        task.resume()
        
        txtUsername.text = ""
        txtPassword.text = ""
            
            println("Internet connection exist!")
        
        } // end of internet checking
        
    }
    
    
    func loadLocation(urlLoadLocation: NSString){
        var u = urlLoadLocation as String
        println(u)
        
        let requestURL:NSURL = NSURL(string:u as String)!
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error)-> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: nil) as! [[String:AnyObject]]
                
                println("Location JSON value: \(json)")
                //"id":1,"is_map":1,"name":"Location Google Map","address":"Sun Valley Drive Para\u00f1aque","image":"55ee7d4f37f2b.jpg","parent":0,"coordinates":"","stat":"2,36,20
                
                var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context: NSManagedObjectContext = AppDel.managedObjectContext!
                
                for j in json as [Dictionary<String, AnyObject>]{
                    let id:Int? = j["id"] as? Int
                    let is_map:Int? = j["is_map"] as? Int
                    let name:String = j["name"] as! String
                    let address:String = j["address"] as! String
                    let image:String = j["image"] as! String
                    let parent:Int = j["parent"] as! Int
                    let coordinates:String = j["coordinates"] as! String
                    let stat:String = j["stat"] as! String
                    
                    var newLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: context) as! NSManagedObject
                    
                    newLocation.setValue(id, forKey: "id")
                    newLocation.setValue(is_map, forKey: "is_map")
                    newLocation.setValue(name, forKey: "name")
                    newLocation.setValue(address, forKey: "address")
                    newLocation.setValue(image, forKey: "image")
                    newLocation.setValue(parent, forKey: "parent")
                    newLocation.setValue(coordinates, forKey: "coordinates")
                    newLocation.setValue(stat, forKey: "stat")
                    
                    context.save(nil)
                    println(newLocation)
                    println("location has been saved!")
                    
                }
            }
        }
        
        task.resume()
    }
    
    
    func loadPreferences(urlLoadPreference: NSString){
        var u = urlLoadPreference as String
        println(u)
        
        let requestURL:NSURL = NSURL(string: u as String)!
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error)-> Void in
            
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: nil) as! [[String:AnyObject]]
                var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context: NSManagedObjectContext = AppDel.managedObjectContext!
                
                for j in json as [Dictionary<String, AnyObject>]{
                    let id:Int? = j["id"] as? Int
                    let namespace = j["namespace"] as! String
                    let pref:String? = j["preference"] as? String
                    let parent = j["parent"] as! String
                    
                    var newPreference = NSEntityDescription.insertNewObjectForEntityForName("Preferences", inManagedObjectContext: context) as! NSManagedObject
                    
                    newPreference.setValue(id, forKey: "id")
                    newPreference.setValue(namespace, forKey: "namespace")
                    newPreference.setValue(pref, forKey: "preference")
                    newPreference.setValue(parent, forKey: "parent")
                    
                    
                    context.save(nil)
                    println("Namespace: \(namespace) , Preferences\(pref), Parent \(parent)")
                    //println("Preference Successfully saved!")
                
                }
            
            }
        
        }
        
        task.resume()
        
    }
    
    func loadNature(urlLoadNature:NSString){
        var y = urlLoadNature as String
        
        let requestURL: NSURL = NSURL(string: y as String)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: nil) as! [[String:AnyObject]]
                var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context: NSManagedObjectContext = AppDel.managedObjectContext!
                for j in json as [Dictionary<String, AnyObject>]{
                    let id:Int? = j["id"] as? Int
                    let admin_id:Int? = j["admin_id"] as? Int
                    let nature:String? = j["nature"] as? String
                    let category_id:Int? = j["category_id"] as? Int
                    let subcategory_id:Int? = j["subcategory_id"] as? Int
                    
                    var natureObj = NSEntityDescription.insertNewObjectForEntityForName("Nature", inManagedObjectContext: context) as! NSManagedObject
                    
                    natureObj.setValue(id, forKey:"id")
                    natureObj.setValue(admin_id, forKey: "admin_id")
                    natureObj.setValue(nature, forKey: "nature")
                    natureObj.setValue(category_id, forKey: "category_id")
                    natureObj.setValue(subcategory_id, forKey: "subcategory_id")
                    
                    context.save(nil)
                    println("Naturevalue has been saved:\(nature)")
                }
                
            }
        }
        
        task.resume()
        
    
    }
    
    func loadHazardOrigin(urlLoadHazardOrigin: NSString){
        
        println("Inside load hazard origin")
        var y = urlLoadHazardOrigin as String
        
        let requestURL: NSURL = NSURL(string: y as String)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
            
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error)->Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: nil) as! [[String:AnyObject]]
                var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context: NSManagedObjectContext = AppDel.managedObjectContext!
                
                //save to database
                
                for j in json as [Dictionary<String, AnyObject>]{
                    let id:Int? = j["id"] as? Int
                    let admin_id:Int? = j["admin_id"] as? Int
                    let parent:Int? = j["parent"] as? Int
                    let origin:String = j["origin"] as! String
                    
                    //var newUnit = NSEntityDescription.insertNewObjectForEntityForName("Unit", inManagedObjectContext: context) as! NSManagedObject
                    var newHazardOrigin = NSEntityDescription.insertNewObjectForEntityForName("HazardOrigin", inManagedObjectContext: context) as! NSManagedObject
                    
                    newHazardOrigin.setValue(id, forKey: "id")
                    newHazardOrigin.setValue(admin_id, forKey: "admin_id")
                    newHazardOrigin.setValue(parent, forKey: "parent")
                    newHazardOrigin.setValue(origin, forKey: "origin")
                    
                    
                    context.save(nil)
                    println("\(newHazardOrigin)")
                    
                }
                
                println("hazard origin : \(json)" )
            }
            
        }
        
        task.resume()
        
    }
    
    
    func loadUnit(urlLoadUnit: NSString){
        var y = urlLoadUnit as String
        //println("unit url value \(urlLoadUnit)")
        
        
        let requestURL:NSURL = NSURL(string: y as String)!
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest){
            (data,response,error)-> Void in
            
            let httpRespose = response as! NSHTTPURLResponse
            let statusCode = httpRespose.statusCode
            
            if statusCode == 200 {
                let json = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: nil) as! [[String:AnyObject]]
                var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context:NSManagedObjectContext = AppDel.managedObjectContext!
                
                
                for j in json as [Dictionary<String, AnyObject>]{
                    
                    
                    let id:Int? = j["id"] as? Int
                    let department_id:Int? = j["department_id"] as? Int
                    let employee_no:Int? = j["employee_no"] as? Int
                    let hours_per_shift:Int? = j["hours_per_shift"] as? Int
                    let is_department:Int? = j["is_department"] as? Int
                    let is_subunit:Int? = j["is_subunit"] as? Int
                    let manhours:Int? = j["manhours"] as? Int
                    let name = j["name"] as? String
                    let parent_id:Int? = j["parent_id"] as? Int
                    let shift_end = j["shift_end"] as! String
                    let shift_start = j["shift_start"] as! String
                    let shift_name = j["shift_name"] as! String
                                        
                    var newUnit = NSEntityDescription.insertNewObjectForEntityForName("Unit", inManagedObjectContext: context) as! NSManagedObject
                    
                     newUnit.setValue(department_id, forKey: "department_id")
                     newUnit.setValue(employee_no, forKey: "employee_no")
                     newUnit.setValue(hours_per_shift, forKey: "hours_per_shift")
                     newUnit.setValue(id, forKey: "id")
                     newUnit.setValue(is_department, forKey: "is_department")
                     newUnit.setValue(is_subunit, forKey: "is_subunit")
                     newUnit.setValue(manhours, forKey: "manhours")
                     newUnit.setValue(name, forKey: "name")
                     newUnit.setValue(parent_id, forKey: "parent_id")
                     newUnit.setValue(shift_end, forKey: "shift_end")
                     newUnit.setValue(shift_name, forKey: "shift_name")
                     newUnit.setValue(shift_start, forKey: "shift_start")
                    
                    context.save(nil)
                    println("Unit: \(newUnit)")
                    
                    println("Successfully saved unit")
                    
                    
                }
                
                //Now save to database
                
            }else{
                println("error loading unit")
            }
        
        }
        
        task.resume()
    }
    

    
    func loadMilestone(urlMilestoneRequest: NSString){
        
        
        let requestURL:NSURL = NSURL(string: urlMilestoneRequest as String)!
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error)-> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                
                let json = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: nil) as! [[String:AnyObject]]
                var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                var context:NSManagedObjectContext = AppDel.managedObjectContext!
                
                for j in json as [Dictionary<String, AnyObject>]{
                    
                    let company = j["company"] as! String
                    let id = j["id"] as! Int
                    let highest = j["highest"] as! Int
                    let value = j["value"] as! Int
                    let unit = j["unit"] as! Int
                    
                    
                    var newMilestone = NSEntityDescription.insertNewObjectForEntityForName("Milestone", inManagedObjectContext: context) as! NSManagedObject
                    
                    newMilestone.setValue(id, forKey: "id")
                    newMilestone.setValue(company, forKey: "company")
                    newMilestone.setValue(highest, forKey: "highest")
                    newMilestone.setValue(value, forKey: "value")
                    newMilestone.setValue(unit, forKey: "unit")
                    
                    context.save(nil)
                    println(newMilestone)
                    
                    
                }
                println("successfully connected to milestone")
                
            }else{
                println("failed getting request milestone")
            }
            
        }
        
        task.resume()
        
    }
    
    
   
}
