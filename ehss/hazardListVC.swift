//
//  hazardListVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/4/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

class hazardListVC: UITableViewController {

 
    var hazardArray:[hazardShort] = [hazardShort]()
    
    struct hazardShort{
        
        var location: Int
        var name: String
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context: NSManagedObjectContext = AppDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Hazard")
        request.returnsObjectsAsFaults = false
        //request.predicate = NSPredicate(format: "parent = %@",hd)
        
        //var hazard1 = hazardShort(location: "test 1", name: "test name 1")
        //var hazard2 = hazardShort(location: "test 2", name: "test name 2")
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            
            for res in results {
                var h:hazardShort? = hazardShort(location: (res.valueForKey("location") as? Int)!, name: (res.valueForKey("name") as? String)!)
                
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
        return hazardArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! myCell

        var h = hazardArray[indexPath.row]
        
        cell.lblHazardLocation.text = getLocationName(h.location) as String
        cell.lblHazardName.text = h.name
        
        
        return cell
    }
    
    func getLocationName(var val:Int) ->String {
        
        
        var id:String = ""
        
        var AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = AppDel.managedObjectContext!
        var request = NSFetchRequest(entityName: "Location")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@",String(val))
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)!
        
        if results.count > 0 {
            var res = results[0] as! NSManagedObject
            id = res.valueForKey("name") as! String
        }else{
            print("Error finding location")
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
