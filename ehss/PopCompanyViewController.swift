//
//  DatePickerActionSheet.swift
//  iDoctors
//
//  Created by Valerio Ferrucci on 30/09/14.
//  Copyright (c) 2014 Tabasoft. All rights reserved.
//

import UIKit
import CoreData

protocol DataCompanyPickerViewControllerDelegate : class {
    
    func companyPickerVCDismissed(value : NSString?, companyId:NSInteger?)
}

class PopCompanyViewController : UIViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var companyPicker: UIPickerView!
    
    var companySelected = ""
    
    
    var company:[String] = [String]()
    
    weak var delegate : DataCompanyPickerViewControllerDelegate?
    
    var currentDate : NSString? {
        didSet {
            //updatePickerCurrentDate()
            
        }
    }
    
    convenience init() {
        
        self.init(nibName: "PopCompanyPicker", bundle: nil)
    }
    
    private func updatePickerCurrentDate() {
        
        if let _currentDate = self.currentDate {
            if let _datePicker = self.companyPicker {
                
            }
        }
    }
    
    @IBAction func okAction(sender: UIButton) {
        
        
        
        self.dismissViewControllerAnimated(false) {
            
            var AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            var context: NSManagedObjectContext = AppDel.managedObjectContext!
            var request = NSFetchRequest(entityName: "Milestone")
            
            request.returnsObjectsAsFaults = false
            //request.predicate = NSPredicate(format: "productname = %@", "(txtName.text)")
            
            request.predicate = NSPredicate(format: "company = %@", "\(self.companySelected)")
            
            var results:NSArray = context.executeFetchRequest(request, error: nil)!
            
            if results.count > 0 {
                for res in results {
                    var id = res.valueForKey("id") as! Int
                    self.delegate?.companyPickerVCDismissed(self.companySelected,companyId:id)
                }
            }
            
            
            //let nsdate = self.datePicker.date
            
            
        }
        
    }
    
    override func viewDidLoad() {
        
        //load value array here
        
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = AppDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Milestone")
        
        request.returnsObjectsAsFaults = false
        //no predicate
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count>0 {
        
            for res in results{
                
                var company = res.valueForKey("company") as! String
                self.company.append(company)
                println(company)
            
            }
            
        }
        updatePickerCurrentDate()
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        self.delegate?.companyPickerVCDismissed(nil,companyId:nil)
    }
    
    //for datepicker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
         return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return company.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return company[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        companySelected = company[row]
        print("Company: \(companySelected)")
    }
    
    
}
