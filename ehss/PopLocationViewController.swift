//
//  PopLocationViewController.swift
//  ehss
//
//  Created by IOS1-PC on 4/13/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.

import UIKit
import CoreData

protocol DataLocationPickerViewControllerDelegate : class {
    
    func locationPickerVCDismissed(value : NSString?)
}

class PopLocationViewController: UIViewController , UIPickerViewDelegate{

    
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var locationPicker: UIPickerView!
    
    var locationSelected = ""
    
    
    var location:[String] = [String]()
    
    weak var delegate : DataLocationPickerViewControllerDelegate?
    
    var currentDate : NSString? {
        didSet {
            //updatePickerCurrentDate()
        }
    }
    
    convenience init() {
        
        self.init(nibName: "PopLocationPicker", bundle: nil)
    }
    
    private func updatePickerCurrentDate() {
        
        //if let _currentDate = self.currentDate {
           // if let _datePicker = self.location{
                
           // }
        //}
    }
    
    @IBAction func okAction(sender: UIButton) {
        
        self.dismissViewControllerAnimated(false) {
            
            //let nsdate = self.datePicker.date
            self.delegate?.locationPickerVCDismissed(self.locationSelected)
            
        }
        
    }
    
    override func viewDidLoad() {
        
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Location")
        
        request.returnsObjectsAsFaults = false
        let results:NSArray = try! context.executeFetchRequest(request)
        if results.count > 0 {
            for res in results {
            
                let loc = res.valueForKey("name") as! String
                self.location.append(loc)
                //println(loc)
            }
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        //self.delegate?.locationPickerVCDismissed(nil)
        self.delegate?.locationPickerVCDismissed(nil)
    }
    
    //for datepicker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return location.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return location[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        locationSelected = location[row]
        print("Dept: \(locationSelected)", terminator: "")
    }
    
    
}
