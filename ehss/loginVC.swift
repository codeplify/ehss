//
//  loginVC.swift
//  ehss
//
//  Created by IOS1-PC on 3/18/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage

var uname: String = ""
var pword: String = ""
var sdomain: String = ""

class loginVC: UIViewController {
    
    
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
  //  let alert = UIAlertView()
    
    var username = ""
    var password = ""
    var s = ""
    
    var urlLoadMilestone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if NSUserDefaults.standardUserDefaults().objectForKey("ehss_username") != nil {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("ehss_username")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("ehss_password")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("subdomain")
        }
        
        //reset database here
        
        resetTable("Milestone")
        resetTable("HazardOrigin")
        resetTable("Preferences")
        resetTable("Unit")
        resetTable("Nature")
        resetTable("Location")
        resetTable("Usercontroller")
        
        // Do any additional setup after loading the view.
    }
    
    func resetTable(let entity:String){
        
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDel.managedObjectContext!
        let coord = appDel.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord?.executeRequest(deleteRequest, withContext: context)
            print("\(entity) has been deleted! ")
        }catch let error as NSError {
            debugPrint(error)
        }
        
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
        
        username = txtUsername.text!
        password = txtPassword.text!
        
        uname = txtUsername.text! as String
        pword = txtPassword.text! as String
        
        let urlLogin = "https://www.ehss.net/mobile/mobile_login?username=\(username)&password=\(password)"
        
       // urlLoadMilestone = "https://test.ehss.net/mobile/milestone/username/\(username)/password/\(password)"
        
        let requestURL:NSURL = NSURL(string: urlLogin)!
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
                
        let task = session.dataTaskWithRequest(urlRequest){
            (data,response,error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if(statusCode==200){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! [String:AnyObject]
                
                
                if let retrieve = json["retrieve"] as? String{
                    
                    
                    if retrieve == "failed" {
                        
                        //self.alert.title = "Error Message"
                        //self.alert.message = "Invalid Username/Password"
                        //self.alert.addButtonWithTitle("Ok")
                        //self.alert.show()
                        
                        print("Error logging in to Ehss.net", terminator: "")
                        
                    }

                    
                    if let subdomain = json["subdomain"] as? String{
                        
                        
                        self.s = subdomain
                        sdomain = subdomain
                        
                        if retrieve == "success" {
                            print("successfully login", terminator: "")
                            
                            self.userDefaults.setValue(self.username ,forKey: "ehss_username")
                            self.userDefaults.setValue(self.password, forKey: "ehss_password")
                            
                            self.userDefaults.setValue(subdomain, forKey: "subdomain")
                            
                            self.loadUnit(loginVC.loadUnitString(subdomain, uname: self.username, pword: self.password))
                            self.loadPreferences(loginVC.loadPreferencesString(subdomain, uname: self.username, pword: self.password))
                            self.loadLocation(loginVC.loadLocationString(subdomain, uname: self.username, pword: self.password))
                            self.loadHazardOrigin(loginVC.loadHazardOriginString(subdomain, uname: self.username, pword: self.password))
                            self.loadNature(loginVC.loadNatureString(subdomain, uname: self.username, pword: self.password))
                            self.loadPieChartData()
                            self.loadGraphData()
                            self.urlLoadMilestone = "https://\(subdomain).ehss.net/mobile/milestone/username/\(self.username)/password/\(self.password)"
                            //self.loadChecklistData()
                            self.loadAllUsers()
                            /*
                                Save here the user controller value in CoreData
                            */
                            
                            let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                            
                            let context:NSManagedObjectContext = AppDel.managedObjectContext!
                            
                            let newUserController = NSEntityDescription.insertNewObjectForEntityForName("Usercontroller", inManagedObjectContext: context) 
                            
                            newUserController.setValue(1, forKey: "id")
                            newUserController.setValue(subdomain, forKey: "subdomain")
                            
                            do {
                                try context.save()
                            } catch _ {
                            }
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                            print("Usercontroller created! \(newUserController)")
                            
                        }
                        
                    }
                }
                
                
                //println(json)
                
                
                self.loadMilestone(self.urlLoadMilestone)
                
            }else{
                //self.alert.title = "Error Message"
                //self.alert.message = "No internet connection detected."
                //self.alert.addButtonWithTitle("Ok")
                //self.alert.show()
            }
            
        }
        
        
        task.resume()
        
        txtUsername.text = ""
        txtPassword.text = ""
            
            print("Internet connection exist!")
        
         // end of internet checking
        
    }
    
    
    func loadLocation(urlLoadLocation: NSString){
        let u = urlLoadLocation as String
        print(u)
        
        let requestURL:NSURL = NSURL(string:u as String)!
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error)-> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! [[String:AnyObject]]
                
                print("Location JSON value: \(json)")
                //"id":1,"is_map":1,"name":"Location Google Map","address":"Sun Valley Drive Para\u00f1aque","image":"55ee7d4f37f2b.jpg","parent":0,"coordinates":"","stat":"2,36,20
                
                let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context: NSManagedObjectContext = AppDel.managedObjectContext!
                
                for j in json as [Dictionary<String, AnyObject>]{
                    let id:Int? = j["id"] as? Int
                    let is_map:Int? = j["is_map"] as? Int
                    let name:String = j["name"] as! String
                    let address:String = j["address"] as! String
                    let image:String = j["image"] as! String
                    let parent:Int = j["parent"] as! Int
                    let coordinates:String = j["coordinates"] as! String
                    let stat:String = j["stat"] as! String
                    
                    let newLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: context) 
                    
                    newLocation.setValue(id, forKey: "id")
                    newLocation.setValue(is_map, forKey: "is_map")
                    newLocation.setValue(name, forKey: "name")
                    newLocation.setValue(address, forKey: "address")
                    newLocation.setValue(image, forKey: "image")
                    newLocation.setValue(parent, forKey: "parent")
                    newLocation.setValue(coordinates, forKey: "coordinates")
                    newLocation.setValue(stat, forKey: "stat")
                    
                    do {
                        try context.save()
                    } catch _ {
                    }
                    print(newLocation)
                    print("location has been saved!")
                    
                }
            }
        }
        
        task.resume()
    }
    
    func downloadImagesLink(){
        //mobile/getimagenew/username/password/image
    }
    
    
    func loadPreferences(urlLoadPreference: NSString){
        let u = urlLoadPreference as String
        print(u)
        
        let requestURL:NSURL = NSURL(string: u as String)!
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error)-> Void in
            
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! [[String:AnyObject]]
                let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context: NSManagedObjectContext = AppDel.managedObjectContext!
                
                for j in json as [Dictionary<String, AnyObject>]{
                    let id:Int? = j["id"] as? Int
                    let namespace = j["namespace"] as! String
                    let pref:String? = j["preference"] as? String
                    let parent = j["parent"] as! String
                    
                    let newPreference = NSEntityDescription.insertNewObjectForEntityForName("Preferences", inManagedObjectContext: context) 
                    
                    newPreference.setValue(id, forKey: "id")
                    newPreference.setValue(namespace, forKey: "namespace")
                    newPreference.setValue(pref, forKey: "preference")
                    newPreference.setValue(parent, forKey: "parent")
                    
                    
                    do {
                        try context.save()
                    } catch _ {
                    }
                    print("Namespace: \(namespace) , Preferences\(pref), Parent \(parent)")
                    //println("Preference Successfully saved!")
                
                }
            
            }
        
        }
        
        task.resume()
        
    }
    
    func loadNature(urlLoadNature:NSString){
        let y = urlLoadNature as String
        
        let requestURL: NSURL = NSURL(string: y as String)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! [[String:AnyObject]]
                let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context: NSManagedObjectContext = AppDel.managedObjectContext!
                for j in json as [Dictionary<String, AnyObject>]{
                    let id:Int? = j["id"] as? Int
                    let admin_id:Int? = j["admin_id"] as? Int
                    let nature:String? = j["nature"] as? String
                    let category_id:Int? = j["category_id"] as? Int
                    let subcategory_id:Int? = j["subcategory_id"] as? Int
                    
                    let natureObj = NSEntityDescription.insertNewObjectForEntityForName("Nature", inManagedObjectContext: context) 
                    
                    natureObj.setValue(id, forKey:"id")
                    natureObj.setValue(admin_id, forKey: "admin_id")
                    natureObj.setValue(nature, forKey: "nature")
                    natureObj.setValue(category_id, forKey: "category_id")
                    natureObj.setValue(subcategory_id, forKey: "subcategory_id")
                    
                    do {
                        try context.save()
                    } catch _ {
                    }
                    print("Naturevalue has been saved:\(nature)")
                }
                
            }
        }
        
        task.resume()
    
    }
    
    func loadMatrix(){
        //mobile/riskmatrix/get_axis/username/
        //mobile/riskmatrix/get_value/username/
        //mobile/getriskscore/username/
        //mobile/getriskscale/username/
        
        //Axis: https://test.ehss.net/mobile/riskmatrix/get_axis/username/test@insafety.com/password/741852963
        //Risk Value: https://test.ehss.net/mobile/getriskscore/username/test@insafety.com/password/741852963
        //Legend: https://test.ehss.net/mobile/getriskscale/username/test@Insafety.com/password/741852963
        
        
        
        let axis = "https://\(sdomain).ehss.net/mobile/riskmatrix/get_axis/username/\(uname)/password/\(pword)"
        let value = "https://\(sdomain).ehss.net/mobile/getriskscore/username/\(uname)/password/\(pword)"
        let legend = "https://\(sdomain).ehss.net/mobile/getriskscale/username/\(uname)/password/\(pword)"
        
        loadRiskMatrix(axis,id: 1)
        loadRiskMatrix(value,id: 2)
        loadRiskMatrix(legend,id: 3)
    }
    
    
    func loadRiskMatrix(let url: String, let id: Int){
      
        
        let requestURL: NSURL = NSURL(string: url as String)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error)->Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments )) as! [[String:AnyObject]]
                let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context: NSManagedObjectContext = AppDel.managedObjectContext!
                
                if id == 1 {
                    for j in json as [Dictionary<String, AnyObject>] {
                        //load value here
                        
                        let id: Int = j["id"] as! Int
                        let name: String = j["name"] as! String
                        let risk_table_id:Int = j["risk_table_id"] as! Int
                        let axis: String = j["axis"] as! String
                        
                        let riskaxis = NSEntityDescription.insertNewObjectForEntityForName("RiskMatrixAxis", inManagedObjectContext: context)
                        
                        riskaxis.setValue(id, forKey: "id")
                        riskaxis.setValue((name), forKey: "name")
                        riskaxis.setValue(risk_table_id, forKey: "risk_table_id")
                        riskaxis.setValue(axis, forKey: "axis")
                        
                        do {
                            try context.save()
                        }catch _ {
                            
                        }
                        
                    }
                    
                    print("Matrix Axis has been loaded!")
                }
                
                if id == 2 {
                    for j in json as [Dictionary<String, AnyObject>]{
                        
                        
                        let id:Int = j["id"] as! Int
                        let value:Int = j["value"] as! Int
                        let risk_id:Int = j["risk_id"] as! Int
                        let scale:Int = j["scale"] as! Int
                        let row:Int = j["row"] as! Int
                        let column:Int = j["column"] as! Int
                        
                        
                        let riskvalue = NSEntityDescription.insertNewObjectForEntityForName("RiskMatrixValue", inManagedObjectContext: context)
                        
                        riskvalue.setValue(id, forKey: "id")
                        riskvalue.setValue(value, forKey: "value")
                        riskvalue.setValue(risk_id, forKey: "risk_id")
                        riskvalue.setValue(scale, forKey: "scale")
                        riskvalue.setValue(row, forKey: "row")
                        riskvalue.setValue(column, forKey: "column")
                        
                        do {
                            try context.save()
                        }catch _ {
                        
                        }
                        
                    }
                    
                    print("matrix value loaded")
                }
                
                if id == 3 {
                    for j in json as [Dictionary<String, AnyObject>] {
                        let id: Int = j["id"] as! Int
                        let count: Int = j["count"] as! Int
                        let scale: String = j["scale"] as! String
                        let color: String = j["color"] as! String
                        
                        
                        let risklegend = NSEntityDescription.insertNewObjectForEntityForName("RiskMatrixLegend", inManagedObjectContext: context)
                        
                        risklegend.setValue(id, forKey: "id")
                        risklegend.setValue(count, forKey: "count")
                        risklegend.setValue(scale, forKey: "scale")
                        risklegend.setValue(color, forKey: "color")
                        
                        do {
                            try context.save()
                        }catch _ {
                        
                        }
                    }
                    
                    print("matrix legend loaded!")
                }
            }
        }
        
        task.resume()
        
    }
    
    func loadHotspotMap(){
        //load hotspot map values
        
        //let y = "https://\(sdomain).ehss.net/mobile/get_users/username/\(uname)/password/\(pword)"
        
    }
    
    
    func loadAllUsers(){
        let y = "https://\(sdomain).ehss.net/mobile/get_users/username/\(uname)/password/\(pword)"
        
        let requestURL: NSURL = NSURL(string: y as String)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! [[String:AnyObject]]
                let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context: NSManagedObjectContext = AppDel.managedObjectContext!
                for j in json as [Dictionary<String, AnyObject>]{
                    let id:Int? = j["id"] as? Int
                    let email:String? = j["email"] as? String
                    let name:String? = j["name"] as? String
                    let role : Int? = j["role"] as? Int
                    let access : String? = j["access"] as? String
                    
                    
                    let allUser = NSEntityDescription.insertNewObjectForEntityForName("AllUser", inManagedObjectContext: context) 
                    
                    allUser.setValue(id, forKey: "id")
                    allUser.setValue(email, forKey: "email")
                    allUser.setValue(name, forKey: "name")
                    allUser.setValue(role, forKey: "role")
                    allUser.setValue(access, forKey: "access")
                    
                    
                    do {
                        try context.save()
                    } catch _ {
                    }
                    
                    print("all user has been loaded")

                }
            }
            
        }
        
        task.resume()

        
        
        
    }
    
    func loadChecklistData(){
        let y = "https://\(sdomain).ehss.net/mobile/get_checklist/username/\(uname)/password/\(pword)"
        
        let requestURL: NSURL = NSURL(string: y as String)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! [[String:AnyObject]]
                let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context: NSManagedObjectContext = AppDel.managedObjectContext!
                for j in json as [Dictionary<String, AnyObject>]{
                    let id:Int? = j["id"] as? Int
                    let name:Int? = j["name"] as? Int
                    let category_id:Int? = j["category_id"] as? Int
                    let desc : String? = j["description"] as? String
                    let reference : String? = j["reference"] as? String
                    
                    
                    let checklist = NSEntityDescription.insertNewObjectForEntityForName("Checklist", inManagedObjectContext: context) 
                    
                    checklist.setValue(id, forKey: "id")
                    checklist.setValue(name, forKey: "name")
                    checklist.setValue(category_id, forKey: "category_id")
                    checklist.setValue(desc, forKey: "desc")
                    checklist.setValue(reference, forKey: "reference")
                    
                    
                    do {
                        try context.save()
                    } catch _ {
                    }
                    
                    print("Checklist data response")
                    /*natureObj.setValue(id, forKey:"id")
                    natureObj.setValue(admin_id, forKey: "admin_id")
                    natureObj.setValue(nature, forKey: "nature")
                    natureObj.setValue(category_id, forKey: "category_id")
                    natureObj.setValue(subcategory_id, forKey: "subcategory_id")
                    
                    context.save(nil)
                    println("Naturevalue has been saved:\(nature)") */
                }
                
            }
        }
        
        task.resume()
    }
    
    /*func loadComplianceCat(){
    
        var y = ""
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
                    //IncidentSeverityData
                    let id:Int? = j["id"] as? Int
                    let chart:String? = j["chart"] as? String
                    let value1:String? = j["value1"] as? String
                    let value2:String? = j["value2"] as? String
                    
                    var graphData = NSEntityDescription.insertNewObjectForEntityForName("GraphData", inManagedObjectContext: context) as! NSManagedObject
                    
                    graphData.setValue(id, forKey:"id")
                    graphData.setValue(chart, forKey: "chart")
                    graphData.setValue(value1, forKey: "value1")
                    graphData.setValue(value2, forKey: "value2")
                    
                    context.save(nil)
                  
                }
            }
        }
    } */
    
    func loadGraphData(){
        let y = "https://\(sdomain).ehss.net/mobile/charts/username/\(uname)/password/\(pword)"
        
        let requestURL: NSURL = NSURL(string: y as String)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error)->Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! [[String:AnyObject]]
                let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context: NSManagedObjectContext = AppDel.managedObjectContext!
                
                //save to database
                
                for j in json as [Dictionary<String, AnyObject>]{
                    //IncidentSeverityData
                    let id:Int? = j["id"] as? Int
                    let chart:String? = j["chart"] as? String
                    let value1:String? = j["value1"] as? String
                    let value2:String? = j["value2"] as? String
                    
                    let graphData = NSEntityDescription.insertNewObjectForEntityForName("GraphData", inManagedObjectContext: context) 
                    
                    graphData.setValue(id, forKey:"id")
                    graphData.setValue(chart, forKey: "chart")
                    graphData.setValue(value1, forKey: "value1")
                    graphData.setValue(value2, forKey: "value2")
                    
                    do {
                        try context.save()
                    } catch _ {
                    }
                    print("graph data has been saved! \(graphData)")
                    
                    /* swift 1
                    var fullName = "First Last"
                    var fullNameArr = split(fullName) {$0 == " "}
                    var firstName: String = fullNameArr[0]
                    var lastName: String? = fullNameArr.count > 1 ? fullNameArr[1] : nil
                    */
                    
                    /*
                    let fullName = "First Last"
                    let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
                    // or simply:
                    // let fullNameArr = fullName.characters.split{" "}.map(String.init)
                    
                    fullNameArr[0] // First
                    fullNameArr[1] // Last
                    */
                    
                }
            }
        }
        
        task.resume()
        
    }
    
    func loadPieChartData(){
        
        let y = "https://\(sdomain).ehss.net/mobile/getpie/username/\(uname)/password/\(pword)/year/2016"
        
        let requestURL: NSURL = NSURL(string: y as String)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error)->Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! [[String:AnyObject]]
             //   let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
               // var context: NSManagedObjectContext = AppDel.managedObjectContext!
                
                //save to database
                
                for j in json as [Dictionary<String, AnyObject>]{
                    //IncidentSeverityData
                   // let data:Int? = j["data"] as? Int
                    let label:String? = j["label"] as? String
                    print("label for pie =>\(label)")
                }
            }
        }
        
        task.resume()
        
    }
    
    func loadHazardOrigin(urlLoadHazardOrigin: NSString){
        
        print("Inside load hazard origin")
        let y = urlLoadHazardOrigin as String
        
        let requestURL: NSURL = NSURL(string: y as String)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
            
        let task = session.dataTaskWithRequest(urlRequest){
            (data, response, error)->Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if statusCode == 200 {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! [[String:AnyObject]]
                let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context: NSManagedObjectContext = AppDel.managedObjectContext!
                
                //save to database
                
                for j in json as [Dictionary<String, AnyObject>]{
                    let id:Int? = j["id"] as? Int
                    let admin_id:Int? = j["admin_id"] as? Int
                    let parent:Int? = j["parent"] as? Int
                    let origin:String = j["origin"] as! String
                    
                    //var newUnit = NSEntityDescription.insertNewObjectForEntityForName("Unit", inManagedObjectContext: context) as! NSManagedObject
                    let newHazardOrigin = NSEntityDescription.insertNewObjectForEntityForName("HazardOrigin", inManagedObjectContext: context) 
                    
                    newHazardOrigin.setValue(id, forKey: "id")
                    newHazardOrigin.setValue(admin_id, forKey: "admin_id")
                    newHazardOrigin.setValue(parent, forKey: "parent")
                    newHazardOrigin.setValue(origin, forKey: "origin")
                    
                    
                    do {
                        try context.save()
                    } catch _ {
                    }
                    print("\(newHazardOrigin)")
                    
                }
                
                print("hazard origin : \(json)" )
            }
            
        }
        
        task.resume()
        
    }
    
    
    func loadUnit(urlLoadUnit: NSString){
        let y = urlLoadUnit as String
        //println("unit url value \(urlLoadUnit)")
        
        
        let requestURL:NSURL = NSURL(string: y as String)!
        let urlRequest:NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest){
            (data,response,error)-> Void in
            
            let httpRespose = response as! NSHTTPURLResponse
            let statusCode = httpRespose.statusCode
            
            if statusCode == 200 {
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! [[String:AnyObject]]
                let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context:NSManagedObjectContext = AppDel.managedObjectContext!
                
                
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
                                        
                    let newUnit = NSEntityDescription.insertNewObjectForEntityForName("Unit", inManagedObjectContext: context) 
                    
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
                    
                     do {
                         try context.save()
                     } catch _ {
                        
                     }
                    print("Unit: \(newUnit)")
                    
                    print("Successfully saved unit")
                    
                    
                }
                
                //Now save to database
                
            }else{
                print("error loading unit")
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
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! [[String:AnyObject]]
                let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                let context:NSManagedObjectContext = AppDel.managedObjectContext!
                
                for j in json as [Dictionary<String, AnyObject>]{
                    
                    let company = j["company"] as! String
                    let id = j["id"] as! Int
                    let highest = j["highest"] as! Int
                    let value = j["value"] as! Int
                    let unit = j["unit"] as! Int
                    
                    
                    let newMilestone = NSEntityDescription.insertNewObjectForEntityForName("Milestone", inManagedObjectContext: context) 
                    
                    newMilestone.setValue(id, forKey: "id")
                    newMilestone.setValue(company, forKey: "company")
                    newMilestone.setValue(highest, forKey: "highest")
                    newMilestone.setValue(value, forKey: "value")
                    newMilestone.setValue(unit, forKey: "unit")
                    
                    do {
                        try context.save()
                    } catch _ {
                        
                    }
                    print(newMilestone)
                    
                    
                }
                print("successfully connected to milestone")
                
            }else{
                print("failed getting request milestone")
            }
        }
        
        task.resume()
    }
    
    
   
}

