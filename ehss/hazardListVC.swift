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
     var hazardArray:[hazardShort] = [hazardShort]()
    
    struct hazardShort{
        var location: Int
        var name: String
        var id:Int
        
    }
    
    var delegate:HazardListDelegate! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                //managedObjectIDForURIRepresentation
                //let i = res.identifier! as String
                
               // let i:String = (res.identifier)!
                
                
                let h:hazardShort? = hazardShort(location: (res.valueForKey("location") as? Int)!, name: (res.valueForKey("name") as? String)!, id:(res.valueForKey("id") as? Int)!)
                //print("res identifier : \(i)")
                hazardArray.append(h!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
       
        /*
         let storyboard : UIStoryboard = UIStoryboard(name: "AccountStoryboard", bundle: nil)
         let vc : WelcomeViewController = storyboard.instantiateViewControllerWithIdentifier("WelcomeID") as WelcomeViewController
         vc.teststring = "hello"
         
         let navigationController = UINavigationController(rootViewController: vc)
         
         self.presentViewController(navigationController, animated: true, completion: nil)
         */
        //if (delegate != nil){
                      
            let story: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let editVC: hazardVC = story.instantiateViewControllerWithIdentifier("HazardVC") as! hazardVC
            
            editVC.hazardId = hazardArray[indexPath.row].id
        
            let navigationController = UINavigationController(rootViewController: editVC)
            self.presentViewController(navigationController, animated: true, completion: nil)
        
        
        //}
        
        //let storyboard: UIStoryboard = self.storyboard!
        
        
        
        
        /*
         
        let hazardSelected = hazardArray[indexPath.row]
        
        let editVC:hazardVC = self.storyboard?.instantiateViewControllerWithIdentifier("HazardVC") as! hazardVC
        
        self.presentViewController(editVC, animated: true, completion: nil)
         
         */
        //Alert.show("Hazard", message: "Id: \(hazardSelected.id) , Name: \(hazardSelected.name)", vc: self)
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
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
