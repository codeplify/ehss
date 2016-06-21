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
            
            let AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            let context: NSManagedObjectContext = AppDel.managedObjectContext!
            let request = NSFetchRequest(entityName: "Milestone")
            
            request.returnsObjectsAsFaults = false
            //request.predicate = NSPredicate(format: "productname = %@", "(txtName.text)")
            
            request.predicate = NSPredicate(format: "company = %@", "\(self.companySelected)")
            
            let results:NSArray = try! context.executeFetchRequest(request)
            
            if results.count > 0 {
                for res in results {
                    let id = res.valueForKey("id") as! Int
                    self.delegate?.companyPickerVCDismissed(self.companySelected,companyId:id)
                }
            }
            
            
            //let nsdate = self.datePicker.date
            
            
        }
        
    }
    
    override func viewDidLoad() {
        
        //load value array here
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Milestone")
        
        request.returnsObjectsAsFaults = false
        //no predicate
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count>0 {
        
            for res in results{
                
                let company = res.valueForKey("company") as! String
                self.company.append(company)
                print(company)
            
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
        print("Company: \(companySelected)", terminator: "")
    }
    
    
}
