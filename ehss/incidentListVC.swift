//
//  incidentListVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/14/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

class incidentListVC: UITableViewController {

    
    var incidentList:[incident] = [incident]()    
    
    @IBOutlet weak var mnuList: UIBarButtonItem!
    
    struct incident{
        var location: Int
        var name: String
        var id:Int
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            mnuList.target = revealViewController()
            mnuList.action = "revealToggle:"
            
            revealViewController().rightViewRevealWidth = 150
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Noi")
        
        request.returnsObjectsAsFaults = false

        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            
            for res in results {
                let h:incident? = incident(location: (res.valueForKey("location") as? Int)!, name: (res.valueForKey("desc") as? String)!,id:(res.valueForKey("id") as? Int)!)
                
                incidentList.append(h!)
                
                    print("Incident location: \(h?.location)")
                    print("Incident Name: \(h?.name)")
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
        return incidentList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("incidentCell", forIndexPath: indexPath) as! incidentListCell
        
        let h:incident = incidentList[indexPath.row]
        
        cell.lblLocation.text = getLocationName(h.location) as String
        cell.lblName.text = h.name
        cell.lblID.text = "\(h.id)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let story: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC: IncidentVC2 = story.instantiateViewControllerWithIdentifier("IncidentVC") as! IncidentVC2
        
            editVC.incidentId = incidentList[indexPath.row].id
        
            let navigationController = UINavigationController(rootViewController: editVC)
            self.presentViewController(navigationController, animated: true, completion: nil)
        
    }
    
    func getLocationName(let val:Int) ->String {
        
        
        var id:String = ""
        
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
