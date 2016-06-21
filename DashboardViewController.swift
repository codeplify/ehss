//
//  DashboardViewController.swift
//  ehss
//
//  Created by IOS1-PC on 23/05/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController {
    
    //load Milestone value
    
    @IBOutlet weak var lblNoLostTime: UILabel!
    @IBOutlet weak var lblNoLostTimeMeasurement: UILabel!
    
    
    @IBOutlet weak var lblHighestNoLostTime: UILabel!
    @IBOutlet weak var lblHighestNoLostTimeMeasurement: UILabel!
    
    
    @IBOutlet weak var lblCompany: UILabel!
    
    
    @IBOutlet weak var lblPopCompany: UIButton!
    @IBOutlet weak var mnuMenuList: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Milestone")
        
        request.returnsObjectsAsFaults = false
        
        do{
            let result:NSArray = try context.executeFetchRequest(request)
            
            if result.count > 0 {
                for r in result {
                    let milestone = r as! NSManagedObject
                    
                    print("company: \(milestone.valueForKey("id")) \(milestone.valueForKey("company")) \(milestone.valueForKey("highest"))")
                    
                }
                
                //Default Value
                let milestone = result[1] as! NSManagedObject
                
                let h = milestone.valueForKey("value") as? Int
                let n = milestone.valueForKey("highest") as? Int
                
                
                
                var unit:String = ""
                
                if(milestone.valueForKey("unit") as? Int == 1){
                    unit = "Days"
                }else{
                    unit = "Hours"
                }
                
                lblCompany.text = milestone.valueForKey("company") as? String
                lblNoLostTime.text = "\(String(h!))"
                lblHighestNoLostTime.text = "\(String(n!))"
                lblHighestNoLostTimeMeasurement.text = unit
                lblNoLostTimeMeasurement.text = unit
                
            }

        }catch{
        
        }
        
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            mnuMenuList.target = revealViewController()
            mnuMenuList.action = "revealToggle:"
            
            revealViewController().rightViewRevealWidth = 150
            // extraButton.target = revealViewController()
            //extraButton.action = "rightRevealToggle:"
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }

        // Do any additional setup after loading the view.
    }
    
    func getMeasurement(){
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
