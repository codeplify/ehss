//
//  ViewController.swift
//  ehss
//
//  Created by IOS1-PC on 3/18/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let userDefaults = NSUserDefaults.standardUserDefaults()

    
    @IBOutlet weak var txtUsername: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
     var popDatePicker : PopDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = AppDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Usercontroller")
        
        request.returnsObjectsAsFaults = false
        //request.predicate = NSPredicate(format: "")
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0{
            var res = results[0] as! NSManagedObject
            
            var subdomain = res.valueForKey("subdomain") as! String
            lblEmail.text = subdomain
            
            
            //get object from the database
            //object.intProperty = NSNumber(int:Int(item["id"] as String))
            
        }else{
            print("0 results")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if userDefaults.valueForKey("ehss_username") != nil && userDefaults.valueForKey("ehss_password") != nil &&
            userDefaults.valueForKey("subdomain") != nil {
            
            var username = userDefaults.valueForKey("ehss_username") as! String
            var password = userDefaults.valueForKey("ehss_password") as! String
          
            var subdomain = userDefaults.valueForKey("subdomain") as! String
            
            //check of sqlite database for user has been save
            //if none
            //create session task and save to database the username value
            //do next login to load users data
            
            var sub = lblEmail.text
            
            var urlLogin2 = "https://\(subdomain).ehss.net/mobile/mobile_login?username=\(username)&password=\(password)"
            
            let requestURL:NSURL = NSURL(string: urlLogin2)!
            let urlRequest:NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest){
                (data, response, error) -> Void in
                
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if statusCode == 200 {

                    let json = NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments, error: nil) as! [String:AnyObject]
                    
                    
                        let mobile = json["mobile_phone"] as? String
                        let role = json["role"] as? Int
                        let email = json["email"] as? String
                        let name = json["name"] as? String
                        let employee_id = json["employee_id"] as? Int
                        let password = json["password"] as? String
                        let company = json["company"] as? Int
                        let user_id = json["user_id"] as? Int
                        let designation = json["designation"] as? Int
                    
                    
                        print("Fullname: \(name)")
                        print("Role: \(role)")
                        print(json)
                    
                            //object.intProperty = NSNumber(int:Int(item["id"] as String))
                    
                    var AppDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    var context:NSManagedObjectContext = AppDel.managedObjectContext!
                    
                    var newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as! NSManagedObject
                    
                }
                
            }
            
            task.resume()
            
        }else{
            self.performSegueWithIdentifier("toLogin", sender: self)
        }
    }
    
   
    @IBAction func btnLogout(sender: UIButton) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("ehss_username")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("ehss_password")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("subdomain")
        
        self.performSegueWithIdentifier("toLogin", sender: self)
        
    }

}

