//  ehss
//
//  Created by IOS1-PC on 4/13/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.

import UIKit
import CoreData

protocol DataHazardTypePickerViewControllerDelegate : class {
    
    func hazardTypePickerVCDismissed(value : NSString?)
}

class PopHazardTypeViewController: UIViewController , UIPickerViewDelegate{
   
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var hazardTypePicker: UIPickerView!
    
    var hazardTypeSelected = ""
    
    
    var hazardType:[String] = [String]()
    
    weak var delegate : DataHazardTypePickerViewControllerDelegate?
    
    var currentDate : NSString? {
        didSet {
            //updatePickerCurrentDate()
        }
    }
    
    var currentHazardData: NSInteger?{
        didSet{
            print("Current Hazard data: \(currentHazardData)", terminator: "")
        }
    }
    
    var currentHazardDataId: NSString?{
        didSet{
            print("Current Hazard String id data: \(currentHazardDataId)", terminator: "")
        }
    }
    
    convenience init() {
        
        self.init(nibName: "PopHazardTypePicker", bundle: nil)
    }
    
    private func updatePickerCurrentDate() {
        
        if let _currentDate = self.currentDate {
            // if let _datePicker = self.location{
            
            // }
        }
    }
    
    @IBAction func okAction(sender: UIButton) {
        
        self.dismissViewControllerAnimated(false) {
            
            //let nsdate = self.datePicker.date
            self.delegate?.hazardTypePickerVCDismissed(self.hazardTypeSelected)
            
        }
        
    }
    
    //
        
      
        
   // }
    
   // override func viewDidAppear(animated: Bool) {
        override func viewDidLoad() {
        var hd = ""
        var hdTable = ""
        var hdVal = ""
        
        
        if let hazardDataType = currentHazardData {
            print("Inside view did load: \(hazardDataType)")
            
            if hazardDataType == 0 {
                //r
                hd = "hazard_type"
                hdTable = "Preferences"
                hdVal = "preference"
                
                
                print("\(hd):\(hdTable): \(hdVal)")
            }
            
            if hazardDataType == 1 {
                hd = "0"
                hdTable = "HazardOrigin"
                hdVal = "origin"
                //request.predicate = NSPredicate(format: "parent = %@","0")
                 print("\(hd):\(hdTable): \(hdVal)")
            }
            
            if hazardDataType == 2 {
                
                //get value
                
                if let currentHazardString = currentHazardDataId{
                    
                    let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
                    let context: NSManagedObjectContext = AppDel.managedObjectContext!
                    let request = NSFetchRequest(entityName: "HazardOrigin")
                    
                    request.returnsObjectsAsFaults = false
                    request.predicate = NSPredicate(format: "origin = %@", currentHazardString)
                    
                    let results:NSArray = try! context.executeFetchRequest(request)
                    if results.count > 0 {
                        for res in results {
                            let originId:Int?  = res.valueForKey("id") as? Int
                            
                            if let oId = originId {
                               hd = "\(oId)"
                            }
                            
                        }
                    }
                    
                    hdTable = "HazardOrigin"
                    hdVal = "origin"
                
                }
            }
        }
        
        
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: hdTable)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "parent = %@",hd)
        
        self.hazardType.removeAll(keepCapacity: false)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        if results.count > 0 {
            for res in results {
                
                let pref:String? = res.valueForKey(hdVal) as? String
                
                print(pref)
                
                if let preference = pref {
                    self.hazardType.append("\(preference)")
                }
                
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.delegate?.hazardTypePickerVCDismissed(nil)
    }
    
    //for datepicker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return hazardType.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return hazardType[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        hazardTypeSelected = hazardType[row]
    }
        
    
}
