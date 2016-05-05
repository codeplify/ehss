//
//  auditInspectionListVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/4/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

class auditInspectionVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtDueDate: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var txtDepartment: UITextField!
    @IBOutlet weak var txtPersonResponsible: UITextField!
    @IBOutlet weak var txtFrequency: UITextField!
    @IBOutlet weak var txtComplianceCategory: UITextField!
    @IBOutlet weak var txtComplianceTitle: UITextField!
    @IBOutlet weak var txtPercentage: UITextField!
    
    var popDatePicker1 : PopDatePicker?
    var popDatePicker2 : PopDatePicker?
    var popLocation : PopLocationPicker?
    var popCompany : PopCompanyPicker?
    var popDepartment : PopDeptPicker?
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popDatePicker1 = PopDatePicker(forTextField: txtStartDate)
        txtStartDate.delegate = self
        
        popDatePicker2 = PopDatePicker(forTextField: txtDueDate)
        txtDueDate.delegate = self
        
        popLocation = PopLocationPicker(forTextField:txtLocation)
        txtLocation.delegate = self
        
        popCompany = PopCompanyPicker(forTextField: txtCompany)
        txtCompany.delegate = self
        
        popDepartment = PopDeptPicker(forTextField: txtDepartment)
        txtDepartment.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resign(){
        txtStartDate.resignFirstResponder()
        txtDueDate.resignFirstResponder()
        txtDepartment.resignFirstResponder()
        txtLocation.resignFirstResponder()
        txtCompany.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if(textField === txtStartDate){
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = formatter.dateFromString(txtStartDate.text)
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
                
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
                
            }
            popDatePicker1!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)

            return false
        }else if(textField === txtDueDate){
            resign()
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            let initDate : NSDate? = formatter.dateFromString(txtDueDate.text)
            
            let dataChangedCallback : PopDatePicker.PopDatePickerCallback = { (newDate : NSDate, forTextField : UITextField) -> () in
                
                forTextField.text = (newDate.ToDateMediumString() ?? "?") as String
              
            }
            popDatePicker2!.pick(self, initDate: initDate, dataChanged: dataChangedCallback)

            return false
        }else if(textField === txtCompany){
            resign()
            let initCompany: NSString? = txtCompany.text
            
            let dataChangedCallback : PopCompanyPicker.PopCompanyPickerCallback = {
                ( newCompany: NSString, newVal : NSInteger,  forTextField: UITextField) -> () in
                
                
                forTextField.text = "\(newCompany)"
                
              
            }
            
            popCompany!.pick(self, initDate:initCompany, dataChanged: dataChangedCallback)

            return false
        }else if(textField === txtDepartment){
            resign()
            
            let initDept:NSString? = txtDepartment.text
            let dataChangedCallback : PopDeptPicker.PopDeptPickerCallback = {
                ( newVal: NSString, forTextField: UITextField ) -> () in
                forTextField.text = "\(newVal)"
                
            }
            
            let companyIdVal:Int? = self.getCompany(txtCompany.text as String)
            
            popDepartment!.pick(self, initDate: initDept, dataChanged: dataChangedCallback, company:companyIdVal!)
            return false;
        
        }else if(textField === txtLocation){
            resign()
            let initLocation:NSString? = txtLocation.text
            let dataChangedCallback: PopLocationPicker.PopLocationPickerCallback = {
                (newVal:NSString, forTextField:UITextField) -> () in
                forTextField.text = "\(newVal)"
            }
            popLocation!.pick(self, initDate: initLocation, dataChanged: dataChangedCallback)
            
            return false
        }else{
            return true;
        }
        
    }
    
    func transition(Sender: UIButton!) {
        //let secondViewController:SecondViewController = SecondViewController()
        //self.presentViewController(secondViewController, animated: true, completion: nil)
    }

  
}
