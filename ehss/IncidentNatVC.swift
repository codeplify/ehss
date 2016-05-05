//
//  IncidentNatVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/4/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

class IncidentNatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var natureList = ["Safety","Environment","Health","Security"]
    var userPref = NSUserDefaults.standardUserDefaults()
    
    struct nature {
        var department:Int
        var description:String
        var nature:Int
        var nature_category:Int
        var time:String
        var date:String
        var location:Int
        var activity:String
        var user_id:Int
        var company_id:Int
        var image:String
        var username:String
        var password:String
    }
    
    var incident:nature = nature(department: 0, description: "", nature: 0, nature_category: 0, time: "", date: "", location: 0, activity: "", user_id: 0, company_id: 0, image: "", username: "", password: "")
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return natureList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell",forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = natureList[indexPath.row]
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let natList = natureList[indexPath.row]
        var selectedNatureListVC:selectNatureListVC = self.storyboard?.instantiateViewControllerWithIdentifier("SelectedNatureController") as! selectNatureListVC
        
        selectedNatureListVC.selectedMainNature = natList as String
        self.presentViewController(selectedNatureListVC, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var btnSave: UIButton!

    @IBAction func btnSave(sender: UIButton) {
        
        println("Incident has saved!")
        
        
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = AppDel.managedObjectContext!
        var newIncident = NSEntityDescription.insertNewObjectForEntityForName("Noi", inManagedObjectContext: context) as! NSManagedObject
        
        
        var userId:Int = 0
        var imageAtt:String = ""
        var username:String = ""
        var password:String = ""
        var subdomain:String = ""
        
        if userPref.valueForKey("ehss_username") != nil  && userPref.valueForKey("ehss_password") != nil && userPref.valueForKey("subdomain") != nil {
            username = userPref.valueForKey("ehss_username") as! String
            password = userPref.valueForKey("ehss_password") as! String
            subdomain = userPref.valueForKey("subdomain") as! String
            userId = 2
        }
        
        newIncident.setValue(incident.department, forKey: "department")
        newIncident.setValue(incident.description, forKey: "description")
        newIncident.setValue(incident.nature, forKey:"nature")
        newIncident.setValue(incident.nature_category, forKey: "nature_category")
        newIncident.setValue(incident.time, forKey: "time") //get from shared preference
        newIncident.setValue(incident.date, forKey: "date")
        newIncident.setValue(incident.location, forKey: "location") // load camera image
        newIncident.setValue(incident.activity, forKey: "activity")
        newIncident.setValue(userId, forKey: "user_id")
        newIncident.setValue(incident.company_id, forKey: "company_id")
        newIncident.setValue(incident.image, forKey: "image")
        newIncident.setValue(username, forKey: "username")
        newIncident.setValue(password, forKey: "password")
        
        
        context.save(nil)

        //mobile/save_noi
        //is_save == 1
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle;

     
        
        var request = NSMutableURLRequest(URL:NSURL(string:"https://\(subdomain).ehss.net/mobile/save_noi")!)
        var session = NSURLSession.sharedSession()
        
        
        
        request.HTTPMethod = "POST"
        
       /* var params = ["date":"\(formatter.stringFromDate(formatter.dateFromString(incident.date)!))","description":"\(hazardDescription.text)","hazard_type":"\(h.hazardType)","hazard_impact":"\(h.hazardImpact)","company":"\(h.company)","department":"\(h.department)","location":"\(h.location)","type_add":"\(h.hazardImpact2)","name":"\(hazardName.text)","user_id":"\(userId)","image_attachment":"\(imageAtt)","username":"\(username)","password":"\(password)"] as Dictionary<String, String> */
        
        
        var params = ["date":"\(formatter.stringFromDate(formatter.dateFromString(incident.date)!))","description":"\(incident.description)","nature":"\(incident.nature)","nature_category":"\(incident.nature_category)","time":"\(incident.time)","date":"\(incident.date)","location":"\(incident.location)","activity":"\(incident.activity)","userid":String(userId),"company_id":"\(incident.company_id)","image_attachment":"\(imageAtt)","username":"\(username)","password":"\(password)"] as Dictionary<String, String>

        
        var paramLength = "\(count(params))"
        
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
        
        //task.resume()
        

        
    }
    
    
 
    
    /*
    @IBOutlet weak var btnSaveIncident: UIButton!
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*
    postParam.put("department", noi.getDepartment());
    postParam.put("description",noi.getDescription());
    postParam.put("nature", String.valueOf(noi.getNature()));
    postParam.put("nature_category", String.valueOf(noi.getNatureCategory()));
    postParam.put("time", noi.getTime());
    postParam.put("date", noi.getDate());
    postParam.put("location", noi.getLocation());
    postParam.put("activity", noi.getActivity());
    postParam.put("user_id",String.valueOf(user.getId()));
    postParam.put("company_id",String.valueOf(noi.getCompany()));
    postParam.put("image", noi.getAttachment());
    
    postParam.put("username", username);
    postParam.put("password", password);
    
    */

}
