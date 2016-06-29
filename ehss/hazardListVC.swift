//
//  hazardListVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/4/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

protocol HazardListDelegate{
    func sendHazard(id :Int)
}

class hazardListVC: UITableViewController {
    
    
    // MARK:- Hazard Variable declaration
    
    var hazardArray:[hazardShort] = [hazardShort]()
    
    // MARK:- Hazard Structure
    struct hazardShort{
        var location: Int
        var name: String
        var id:Int
        
    }
    
    var delegate:HazardListDelegate! = nil
    
    // MARK:- View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Navigation Reveal View Controller
        if self.revealViewController() != nil {
            btnMenuList.target = self.revealViewController()
            btnMenuList.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Hazard")
        
        request.returnsObjectsAsFaults = false
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            
            for res in results {
                
                let h:hazardShort? = hazardShort(location: (res.valueForKey("location") as? Int)!, name: (res.valueForKey("name") as? String)!, id:(res.valueForKey("id") as? Int)!)
                
                hazardArray.append(h!)
            }
        }
    }

  
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return hazardArray.count
    }

    @IBOutlet weak var btnMenuList: UIBarButtonItem!
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! myCell

        let h = hazardArray[indexPath.row]
        
        cell.lblHazardLocation.text = getLocationName(h.location) as String
        cell.lblHazardName.text = h.name
        cell.lblID.text = "\(h.id)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
            let story: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let editVC: hazardVC = story.instantiateViewControllerWithIdentifier("HazardVC") as! hazardVC
                editVC.hazardId = hazardArray[indexPath.row].id
            let navigationController = UINavigationController(rootViewController: editVC)
            self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    func getLocationName(let val : Int) ->String {
        
        var id:String = String(val)
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Location")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@",String(val))
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            id = res.valueForKey("name") as! String
        }else{
            print("Error finding location", terminator: "")
        }
        
        return id
    }

}
