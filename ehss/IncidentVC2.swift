//
//  IncidentVC2.swift
//  ehss
//
//  Created by IOS1-PC on 16/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

// MARK: Unused protocol delegate
protocol IncidentDelegate {
    func incidentCarrier(incident: Incident)
}

class IncidentVC2: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var btnGetImage: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    var incidentId = 0
    let commonUtils = CommonUtils.sharedInstance
    
    @IBAction func btnCameraTapped(sender: UIButton) {
        
        
    }
    @IBOutlet weak var btnCamera: UIButton!
    
    
    // MARK:- Variable Declaration
    var popDatePicker:PopDatePicker?
    var popLocationPicker:PopLocationPicker?
    var popDepartmentPicker:PopDeptPicker?
    var popCompanyPicker:PopCompanyPicker?
    
    var userPref = NSUserDefaults()
    
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtDepartment: UITextField!
    @IBOutlet weak var txtActivity: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtNature: UITextField!
    @IBOutlet weak var lblU: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!

    var delegate:IncidentDelegate? = nil
    
    
    // MARK:-Pick Image using image picker
    @IBAction func btnGetImageTapped(sender: AnyObject) {
        let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    
    // MARK: Image picker Delegate 1
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Image picker Delegate 2
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imgView.contentMode = .ScaleAspectFit
        imgView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK:- Onload of View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if incidentId > 0 {
            //Alert.show("ID", message: "Id \(self.incidentId)", vc: self)
            
            let inc:Incident = CoreDataUtility.getIncident(self.incidentId)
            txtDescription.text = inc.description
            txtActivity.text = inc.activity
            txtCompany.text = CoreDataUtility.getCompany(self.incidentId)
            txtDepartment.text = CoreDataUtility.getDepartment(self.incidentId)
            print("description: \(inc.description)")
            print("image: \(inc.image)")
            
            Alert.show("get image", message: "\(inc.image)", vc: self)
        }
        
        txtDate.text = commonUtils.currentDate()
        txtTime.text = commonUtils.currentTime()
        lblU.text = commonUtils.currentUser()
        
        lblDate.text = commonUtils.currentDate()
        
        popDatePicker = PopDatePicker(forTextField:txtDate)
        txtDate.delegate = self
        
        popLocationPicker = PopLocationPicker(forTextField: txtLocation)
        txtLocation.delegate = self
        
        popDepartmentPicker = PopDeptPicker(forTextField: txtDepartment)
        txtDepartment.delegate = self
        
        popCompanyPicker = PopCompanyPicker(forTextField: txtCompany)
        txtCompany.delegate = self
        
        
        
    }
    
    // MARK: Popup up view combo box required!
    
    func resign(){
        txtDate.resignFirstResponder()
        txtLocation.resignFirstResponder()
        txtDepartment.resignFirstResponder()
        txtCompany.resignFirstResponder()
    }
    
    // MARK: Popup view picker controller required!
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
               // self.incident.date = self.txtDate.text! as String
            }
            
            popDatePicker!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)
            return false
        }else if(textField === txtDepartment){
            resign()
            
            let initDept:NSString? = txtDepartment.text
            let dataChangedCallback : PopDeptPicker.PopDeptPickerCallback = {
                ( newVal: NSString, forTextField: UITextField ) -> () in
                forTextField.text = "\(newVal)"
                //self.incident.department = self.getDepartment(self.txtDepartment.text! as String)
                
            }
            
            let companyIdVal:Int? = self.getCompanyId(txtCompany.text! as String)
            
            popDepartmentPicker!.pick(self, initDate: initDept, dataChanged: dataChangedCallback, company:companyIdVal!)
            
            return false;
            
        }else if(textField === txtCompany){
            resign()
            let initCompany: NSString? = txtCompany.text
            
            let dataChangedCallback : PopCompanyPicker.PopCompanyPickerCallback = {
                ( newCompany: NSString, newVal : NSInteger,  forTextField: UITextField) -> () in
                
                forTextField.text = "\(newCompany)"
                
                
                self.txtDepartment.text = ""
                //self.incident.company = self.getCompany(self.txtCompany.text! as String)
            }
            
            popCompanyPicker!.pick(self, initDate:initCompany, dataChanged: dataChangedCallback)
            
            
            return false;
            
            
        }else if(textField === txtLocation){
            resign()
            
            let initLocation:NSString? = txtLocation.text
            let dataChangedCallback: PopLocationPicker.PopLocationPickerCallback = {
                (newVal:NSString, forTextField:UITextField) -> () in
                forTextField.text = "\(newVal)"
                
               // self.incident.location = self.getLocation(self.txtLocation.text!)
            }
            
            popLocationPicker!.pick(self, initDate: initLocation, dataChanged: dataChangedCallback)
            
            return false
            
        }else{
            return true;
        }
    }
    

    @IBAction func goNature(sender: UIButton) {
        
        
       if validate() {
            
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .NoStyle
        
        let secondTab = self.tabBarController?.viewControllers![1] as! AccordionMenuTableViewController
        
        let company = txtCompany.text! as String
        let department = txtDepartment.text! as String
        
        let date = txtDate.text! as String
        _ = "\(formatter.stringFromDate(formatter.dateFromString(date)!))"
        let time = txtTime.text! as String
        let companyId = getCompanyId(company)
        let departmentId = getDepartment(department)
        let activity = txtActivity.text! as String
        let description = txtDescription.text! as String
        let location = getLocation(txtLocation.text! as String)
        let imgPassed = imgView.image
        
        
        
        //set in the next tab -> userId, natureId, username, password
        
        
        let incident:Incident = Incident(userId: 2, date: date, time: time, companyId: companyId, departmentId: departmentId, activity: activity, description: description, natureId: 0, location: location, natureCat: 0,image:"")
        
        
            secondTab.transferValue = "loey agdan"
            secondTab.incident = incident
            secondTab.imgPassedValue = imgPassed!
        
        self.tabBarController?.selectedIndex = 1
            
        
       }
    }
    
}

// MARK:- Utility functions
extension IncidentVC2{
    func getCompanyId(let strCompany:String)->Int{
        var id:Int = 0
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Milestone")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "company = %@",strCompany)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("Error find company", terminator: "")
        }
        return id
    }
    
    func getDepartment(let strDepartment:String)->Int{
        var id:Int = 0
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Unit")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name = %@", strDepartment)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("Error finding department id", terminator: "")
        }
        
        return id
    }
    
    func getLocation(let strLocation:String)->Int{
        var id:Int = 0
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Location")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name = %@",strLocation)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
        }else{
            print("Error finding location", terminator: "")
        }
        
        return id
        
    }
    
    func validate()->Bool{
        
        var ret:Bool
        
        if txtDate.text == "" {
            Alert.show("Error", message: "Date is required", vc: self)
            ret = false
        }
            
        else if txtTime.text == "" {
            Alert.show("Error", message: "Time is required", vc: self)
            ret = false
        }
            
        else if txtLocation.text == "" {
            Alert.show("Error", message: "Location is required", vc: self)
            ret = false
        }
            
        else if txtCompany.text == "" {
            
            Alert.show("Error", message: "Company is required", vc: self)
            ret = false
        }
            
        else if txtDepartment.text == "" {
            Alert.show("Error", message: "Department is required", vc: self)
            ret = false
            
        }else {
            ret = true
        }
        
        
        return ret
        
    }

}
