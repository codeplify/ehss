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
    
    

    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtDepartment: UITextField!
    @IBOutlet weak var txtActivity: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    
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
    }
    
    var incident:Incident = Incident(date: "", time: "", location: 0, company: 0, department: 0, activity: "", description: "", userId: 0, user: "", password: "")
    
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
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnNext(sender: UIButton) {
        println("Incident has been recorded:\(incident.description)")
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
            let initDate : NSDate? = formatter.dateFromString(txtDate.text)
            
            let dataChangedCallback:PopDatePicker.PopDatePickerCallback = {
                (newDate: NSDate, forTextField: UITextField)->() in
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
                self.incident.date = self.txtDate.text as String
            }
            
            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            return false
        }else if(textField === txtDepartment){
            resign()
            
            let initDept:NSString? = txtDepartment.text
            let dataChangedCallback : PopDeptPicker.PopDeptPickerCallback = {
                ( newVal: NSString, forTextField: UITextField ) -> () in
                forTextField.text = "\(newVal)"
                self.incident.department = self.getDepartment(self.txtDepartment.text as String)
                
            }
            
            let companyIdVal:Int? = self.getCompany(txtCompany.text as String)
            
            popDepartmentPicker!.pick(self, initDate: initDept, dataChanged: dataChangedCallback, company:companyIdVal!)
            
            return false;

        }else if(textField === txtCompany){
            resign()
            let initCompany: NSString? = txtCompany.text
            
            let dataChangedCallback : PopCompanyPicker.PopCompanyPickerCallback = {
                ( newCompany: NSString, newVal : NSInteger,  forTextField: UITextField) -> () in
                
                forTextField.text = "\(newCompany)"
                
                
                self.txtDepartment.text = ""
                self.incident.company = self.getCompany(self.txtCompany.text as String)
            }
            
                popCompanyPicker!.pick(self, initDate:initCompany, dataChanged: dataChangedCallback)
            
            
            return false;

        
        }else if(textField === txtLocation){
            resign()
            
            let initLocation:NSString? = txtLocation.text
            let dataChangedCallback: PopLocationPicker.PopLocationPickerCallback = {
                (newVal:NSString, forTextField:UITextField) -> () in
                forTextField.text = "\(newVal)"
                
                self.incident.location = self.getLocation(self.txtLocation.text)
            }
            
            popLocationPicker!.pick(self, initDate: initLocation, dataChanged: dataChangedCallback)
            
            return false
        
        }else{
            return true;
        }
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
    
}
