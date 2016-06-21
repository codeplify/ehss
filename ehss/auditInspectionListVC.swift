//
//  auditInspectionListVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/14/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

class auditInspectionListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    var auditList:[shortAuditList] = [shortAuditList]()
    
    struct shortAuditList {
        var number: String
        var title: String
        var auditor: String
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return auditList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("auditCell", forIndexPath: indexPath) as! auditListCell
        
        let a:shortAuditList = auditList[indexPath.row]
        
        cell.txtAuditNumber.text = "Audit Number: \(a.number)"
        cell.txtAuditor.text = "Auditor: \(a.auditor)"
        cell.txtAuditTitle.text = "Title: \(a.auditor)"
        
        print("AuditTableCell: \(a.number): \(a.auditor) : \(a.title)")
        
        
        return cell
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "AuditInspection")
        
        request.returnsObjectsAsFaults = false
        //request.predicate = NSPredicate(format: "productname = %@","" + txtName.text)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        if(results.count>0){
            
            for res in results{
            
                
                
                
                let comNumber: String = res.valueForKey("compliance_number") as! String
                let var_title: Int = res.valueForKey("checklist_id") as! Int
                let var_auditor: String = "Loey Agdan"
                
                print("Audit Value: \(comNumber) : \(var_title) : \(var_auditor)")
                
                let audit:shortAuditList = shortAuditList(number: comNumber, title: String(var_title), auditor: var_auditor)
                
                auditList.append(audit)
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    
    

    @IBAction func btnDownloadList(sender: UIButton) {
        print("Downloading")
        
        
        loadAuditInspection()
    }
    
    func loadAuditInspection(){
        let y = "https://test.ehss.net/mobile/get_inspection/username/test@insafety.com/password/741852963"
        
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
                    let compliance_number:String? = j["compliance_number"] as? String
                    let parent_id:Int? = j["parent_id"] as? Int
                    let checklist_id:Int? = j["checklist_id"] as? Int
                    let responsible_id:Int? = j["responsible_id"] as? Int
                    let location_id:Int? = j["location_id"] as? Int
                    let company_id:Int? = j["company_id"] as? Int
                    let department_id:Int? = j["department_id"] as? Int
                    let frequency:Int? = j["frequency"] as? Int
                    let start_date:String? = j["start_date"] as? String
                    let end_date:String? = j["end_date"] as? String
                    let percentage:Int? = j["percentage"] as? Int
                    let status:Int? = j["status"] as? Int
                    
                    let auditObj = NSEntityDescription.insertNewObjectForEntityForName("AuditInspection", inManagedObjectContext: context) 
                    
                    auditObj.setValue(id, forKey:"id")
                    auditObj.setValue(compliance_number, forKey: "compliance_number")
                    auditObj.setValue(parent_id, forKey: "parent_id")
                    auditObj.setValue(checklist_id, forKey: "checklist_id")
                    auditObj.setValue(responsible_id, forKey: "responsible_id")
                    auditObj.setValue(location_id, forKey: "location_id")
                    auditObj.setValue(company_id, forKey: "company_id")
                    auditObj.setValue(department_id, forKey: "department_id")
                    auditObj.setValue(frequency, forKey: "frequency")
                    auditObj.setValue(start_date, forKey: "start_date")
                    auditObj.setValue(end_date, forKey: "end_date")
                    auditObj.setValue(percentage, forKey: "percentage")
                    auditObj.setValue(status, forKey: "status")
                    
                    do {
                        try context.save()
                    } catch _ {
                    }
                    print("Naturevalue has been saved:\(auditObj)")
                }
                
            }
        }
        
        task.resume()
        
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
