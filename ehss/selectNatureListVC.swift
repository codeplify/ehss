//
//  selectNatureListVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/5/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

class selectNatureListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lblSelectedNature: UILabel!
    var selectedMainNature = ""
    
    var natureList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblSelectedNature.text = selectedMainNature
        
        //Load nature list from the CoreData
        
        var queryValue = ""
        
        switch(selectedMainNature){
            case "Safety":
                queryValue = "1"
            case "Environment":
                queryValue = "2"
            case "Health":
                queryValue = "3"
            case "Security":
                queryValue = "4"
            default:
                queryValue = "0"
        }
        
        
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Nature")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "category_id = %@",queryValue )
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if(results.count>0){
            for res in results{
            
                
                //var res = rras! NSManagedObject
                let nname = res.valueForKey("nature") as! String
                var sub = res.valueForKey("subcategory_id") as! Int
                natureList.append("\(nname)")
                //natureList.append("\(nname) sub-> \(sub)")
            }
        }else{
            print("0 results")
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return natureList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectedCell",forIndexPath: indexPath) 
        
        //test here if it is subcategory or a header 
        //getting if the subcategory_id value == 0
        
        cell.textLabel?.text = natureList[indexPath.row]
        
        if(isHeader(natureList[indexPath.row]) == 1){
            //cell.textLabel?.backgroundColor = UIColor.greenColor()
        }
        
        //search one by one
        //change the background color if header
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Selected : \(natureList[indexPath.row])")
      
        let incidentNat:IncidentNatVC = self.storyboard?.instantiateViewControllerWithIdentifier("incidentNat") as! IncidentNatVC
        
        incidentNat.selectedNatureCat = natureList[indexPath.row]
        
        self.presentViewController(incidentNat, animated: true, completion: nil)
    }
    
    func isHeader(var value:String)->Int{
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Nature")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "nature = %@",value )
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if(results.count>0){
            
            let res = results[0] as! NSManagedObject
            let sub = res.valueForKey("subcategory_id") as! Int
            
            if sub == 0 {
                return 1
            }else{
                return 0
            }
            
        }else{
            return 0
        }
        
    }
}
