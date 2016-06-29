//
//  AccordionMenuTableViewController.swift
//  ehss
//
//  Created by IOS1-PC on 15/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

var userPref = NSUserDefaults()
var username = ""
var password = ""
var subdomain = ""

class AccordionMenuTableViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,IncidentDelegate{
    
    var incident : Incident? = nil
    var selectedNature = ""

    @IBOutlet weak var tableView: UITableView!
    var parentMenu:[String] = ["Safety","Environment","Health","Security"]
    
    @IBAction func btnSubmitAction(sender: UIButton) {
        
        //save first
        
        if userPref.valueForKey("ehss_username") != nil && userPref.valueForKey("ehss_password") != nil && userPref.valueForKey("subdomain") != nil {
        
            username = userPref.valueForKey("ehss_username") as! String
            password = userPref.valueForKey("ehss_password") as! String
            subdomain = userPref.valueForKey("subdomain") as! String
           
        }
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let newIncident = NSEntityDescription.insertNewObjectForEntityForName("Noi", inManagedObjectContext: context)
        let getNatureVar = getNatureIds(selectedNature)
        if(incident != nil){
            
            //generate id
            newIncident.setValue(CoreDataUtility.getIncrementedId("Noi"), forKey: "id")
            newIncident.setValue(incident!.departmentId!, forKey: "department")
            newIncident.setValue(incident!.description!, forKey: "desc")
            newIncident.setValue(getNatureVar.0, forKey:"nature")
            newIncident.setValue(getNatureVar.1, forKey: "nature_category")
            newIncident.setValue(incident!.time!, forKey: "time")
            newIncident.setValue(incident!.date!, forKey: "date")
            newIncident.setValue(incident!.location!, forKey: "location") // load camera image
            newIncident.setValue(incident!.description!, forKey: "desc")
            newIncident.setValue(incident!.activity!, forKey: "activity")
            newIncident.setValue(CoreDataUtility.getUserId(username), forKey: "user_id")
            newIncident.setValue(incident!.companyId!, forKey: "company_id")
           // newIncident.setValue(incident!.image!, forKey: "image")
            
            
            do{
                try context.save()
            }catch _{
            
            }
        }
        
        let commonUtil:CommonUtils = CommonUtils.sharedInstance
        
        print("<===============Parameter to send===========>")
        
        print("department: \(incident!.departmentId!)")
        print("date\(incident!.description!)")
        print("time \(incident!.time!)")
        print("location\(incident!.location!)")
        print("nature\(getNatureVar.0)")
        print("nature_category\(getNatureVar.1)")
        print("desc\(incident!.description!)")
        print("activity\(incident!.activity!)")
        print("company_id: \(incident!.companyId!)")
        print("user_id: \(CoreDataUtility.getUserId(username))")
        print("username: \(username)")
        print("password: \(commonUtil.currentPassword())")
        
        print("<=======>")
        
        
        let inc:Incident = Incident(userId: CoreDataUtility.getUserId(username), date: incident!.date!, time: incident!.time!, companyId: incident!.companyId!, departmentId: incident!.departmentId!, activity: incident!.activity!, description: incident!.description!, natureId: getNatureVar.0, location: incident!.location!, natureCat: getNatureVar.1, image: "")
        
        
        
       saveOnline(inc)
        
    }
    
    func saveOnline(let incident: Incident){
        
        let request = NSMutableURLRequest(URL:NSURL(string:"https://\(subdomain).ehss.net/mobile/save_noi")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let params = [
            
        
            "department":"\(incident.departmentId)",
            "description":"\(incident.description)",
            "nature":"\(incident.natureId)",
            "nature_category":"\(incident.natureCategory)",
            "time":"\(incident.time)",
            "date":"\(incident.date)",
            "location":"\(incident.location)",
            "activity":"\(incident.activity)",
            "user_id":"\(incident.userId)",
            "company_id":"\(incident.companyId)",
            "image":"\(incident.image)",
            "username":"\(username)",
            "password":"\(password)"
 
 
            
            ] as Dictionary<String, String>
        
        
        for (key,value) in params{
            print("params=> \(key): \(value)")
        }
        
        do{
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
            request.addValue("\(params.count)", forHTTPHeaderField: "Content-Length")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let task = session.dataTaskWithRequest(request){
                data, response, error -> Void in
                
                if let httpStatus = response as? NSHTTPURLResponse {
                    
                    if httpStatus.statusCode == 200 {
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as! NSDictionary
                            
                            
                        }catch{
                            let jsonStr = NSString(data:data!, encoding:NSUTF8StringEncoding)
                            print("Error could not parse json: \(jsonStr)")
                        }
                    }
                
                }else {
                    print("Error saving : \(response)")
                }
            }
        
            //task.resume()
        
        }catch{
            request.HTTPBody = nil
        }
        
    }
    
    //Mark: Delegate
    
    func incidentCarrier(incident: Incident) {
        
        print("Incident : \(incident.activity)")
    }
    
    
    var transferValue:String = ""
    
    var childList1:[String] = [String]()
    var childList2: [String] = [String]()
    var childList3:[String] = [String]()
    var childList4:[String] = [String]()
    
    
    var allChild:[[String]] = [[String]]()
    /// The number of elements in the data source
    var total = 0
    
    /// The identifier for the parent cells.
    let parentCellIdentifier = "ParentCell"
    
    /// The identifier for the child cells.
    let childCellIdentifier = "ChildCell"
    
    /// The data source  
    var dataSource: [Parent]!
    
    /// Define wether can exist several cells expanded or not.
    let numberOfCellsExpanded: NumberOfCellExpanded = .One
    
    /// Constant to define the values for the tuple in case of not exist a cell expanded.
    let NoCellExpanded = (-1, -1)
    
    /// The index of the last cell expanded and its parent.
    var lastCellExpanded : (Int, Int)!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (incident != nil){
            
            /*
            print("Activity : \(incident!.activity!)")
            print("Date : \(incident!.date!)")
            print("Time : \(incident!.time!)")
            print("Department: \(incident!.departmentId!)")
            print("Location: \(incident!.location!)")
            print("description : \(incident!.description!)")*/
            
            
        }
        
        
        generateNatureList(parentMenu[0])
        generateNatureList(parentMenu[1])
        generateNatureList(parentMenu[2])
        generateNatureList(parentMenu[3])

        
        allChild.append(childList1)
        allChild.append(childList2)
        allChild.append(childList3)
        allChild.append(childList4)
        
        self.setInitialDataSource(numberOfRowParents: 4, numberOfRowChildPerParent: 3)
        self.lastCellExpanded = NoCellExpanded
    }
    
    func getNatureIds(let value: String) -> (Int, Int){
        var id:Int = 0
        var category_id:Int = 0
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Nature")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "nature = %@", value)
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            
            let res = results[0] as! NSManagedObject
            id = res.valueForKey("id") as! Int
            category_id = res.valueForKey("category_id") as! Int
            
        }else{
            print("Error finding department id", terminator: "")
        }
        
        
        return (id,category_id)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    private func generateNatureList(let natureMain:String){
        
        var queryValue = ""
        
        switch(natureMain){
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
                            
                
                let nname = res.valueForKey("nature") as! String
                var sub = res.valueForKey("subcategory_id") as! Int
                
                
                if queryValue == "1" {
                    childList1.append(nname)
                }
                
                if queryValue == "2" {
                    childList2.append(nname)
                }
                
                if queryValue == "3" {
                    childList3.append(nname)
                }
                
                if queryValue == "4" {
                    childList4.append(nname)
                }
                
                //var res = rras! NSManagedObject
                //let nname = res.valueForKey("nature") as! String
                //var sub = res.valueForKey("subcategory_id") as! Int
                //natureList.append("\(nname)")
                //natureList.append("\(nname) sub-> \(sub)")
            }
        }else{
            print("0 results")
        }

        
        
    }
    
    private func setInitialDataSource(numberOfRowParents parents: Int, numberOfRowChildPerParent childs: Int) {
        
        // Set the total of cells initially.
        self.total = parents
        
        let data = [Parent](count: parents, repeatedValue: Parent(state: .Collapsed, childs: [String](), title: "test-data"))
        
        dataSource = data.enumerate().map({ (index: Int, element: Parent) -> Parent in
            
            var newElement = element
            
            newElement.title = "\(parentMenu[index])"
            
            // generate the random number between 0...childs
            let random = Int(arc4random_uniform(UInt32(childs + 1)))
            
            // create the array for each cell
            //newElement.childs = (0..<10).enumerate().map {"Subitem \($0.index)"}
            
            var childBelong:[String] = allChild[index]
            
            newElement.childs = (0..<childBelong.count).enumerate().map{ "\(childBelong[$0.index])" }
            
            // for i in allChild[index] {
            //  newElement.childs = (0..<i).enumerate().map{ " \(i[$0.index]) " }
            //}
            
            return newElement
        })
    }
    
    /**
     Expand the cell at the index specified.
     
     - parameter index: The index of the cell to expand.
     */
    private func expandItemAtIndex(index : Int, parent: Int) {
        
        // the data of the childs for the specific parent cell.
        let currentSubItems = self.dataSource[parent].childs
        
        // update the state of the cell.
        self.dataSource[parent].state = .Expanded
        
        // position to start to insert rows.
        var insertPos = index + 1
        
        let indexPaths = (0..<currentSubItems.count).map { _ -> NSIndexPath in
            let indexPath = NSIndexPath(forRow: insertPos, inSection: 0)
            insertPos += 1
            return indexPath
        }
        
        // insert the new rows
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
        // update the total of rows
        self.total += currentSubItems.count
    }
    
    /**
     Collapse the cell at the index specified.
     
     - parameter index: The index of the cell to collapse
     */
    private func collapseSubItemsAtIndex(index : Int, parent: Int) {
        
        var indexPaths = [NSIndexPath]()
        
        let numberOfChilds = self.dataSource[parent].childs.count
        
        // update the state of the cell.
        self.dataSource[parent].state = .Collapsed
        
        guard index + 1 <= index + numberOfChilds else { return }
        
        // create an array of NSIndexPath with the selected positions
        indexPaths = (index + 1...index + numberOfChilds).map { NSIndexPath(forRow: $0, inSection: 0)}
        
        // remove the expanded cells
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        
        // update the total of rows
        self.total -= numberOfChilds
    }
    
    /**
     Update the cells to expanded to collapsed state in case of allow severals cells expanded.
     
     - parameter parent: The parent of the cell
     - parameter index:  The index of the cell.
     */
    private func updateCells(parent: Int, index: Int) {
        
        switch (self.dataSource[parent].state) {
            
        case .Expanded:
            self.collapseSubItemsAtIndex(index, parent: parent)
            self.lastCellExpanded = NoCellExpanded
            
        case .Collapsed:
            switch (numberOfCellsExpanded) {
            case .One:
                // exist one cell expanded previously
                if self.lastCellExpanded != NoCellExpanded {
                    
                    let (indexOfCellExpanded, parentOfCellExpanded) = self.lastCellExpanded
                    
                    self.collapseSubItemsAtIndex(indexOfCellExpanded, parent: parentOfCellExpanded)
                    
                    // cell tapped is below of previously expanded, then we need to update the index to expand.
                    if parent > parentOfCellExpanded {
                        let newIndex = index - self.dataSource[parentOfCellExpanded].childs.count
                        self.expandItemAtIndex(newIndex, parent: parent)
                        self.lastCellExpanded = (newIndex, parent)
                    }
                    else {
                        self.expandItemAtIndex(index, parent: parent)
                        self.lastCellExpanded = (index, parent)
                    }
                }
                else {
                    self.expandItemAtIndex(index, parent: parent)
                    self.lastCellExpanded = (index, parent)
                }
            case .Several:
                self.expandItemAtIndex(index, parent: parent)
            }
        }
    }
    
    /**
     Find the parent position in the initial list, if the cell is parent and the actual position in the actual list.
     
     - parameter index: The index of the cell
     
     - returns: A tuple with the parent position, if it's a parent cell and the actual position righ now.
     */
    private func findParent(index : Int) -> (parent: Int, isParentCell: Bool, actualPosition: Int) {
        
        var position = 0, parent = 0
        guard position < index else { return (parent, true, parent) }
        
        var item = self.dataSource[parent]
        
        repeat {
            
            switch (item.state) {
            case .Expanded:
                position += item.childs.count + 1
            case .Collapsed:
                position += 1
            }
            
            parent += 1
            
            // if is not outside of dataSource boundaries
            if parent < self.dataSource.count {
                item = self.dataSource[parent]
            }
            
        } while (position < index)
        
        // if it's a parent cell the indexes are equal.
        if position == index {
            return (parent, position == index, position)
        }
        
        item = self.dataSource[parent - 1]
        return (parent - 1, position == index, position - item.childs.count - 1)
    }
}

extension AccordionMenuTableViewController {
    
    // MARK: UITableViewDataSource
    
    func isSubMain(let str:String)->Bool{
        
        var ret:Bool = false
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Nature")
        
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "nature = %@", str)
       
        do{
             let result:NSArray = try context.executeFetchRequest(request)
            
            
            if(result.count>0){
                
                let res = result[0] as! NSManagedObject
                let nat = res.valueForKey("subcategory_id") as! Int
                
                if nat == 0 {
                    ret = true
                }else{
                    ret = false
                }
                
                
            }else{
                
                ret = false
            }

        }catch{
        
        }
        
        return ret
      
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.total
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell!
        
        let (parent, isParentCell, actualPosition) = self.findParent(indexPath.row)
        
        if !isParentCell {
            cell = tableView.dequeueReusableCellWithIdentifier(childCellIdentifier, forIndexPath: indexPath)
            cell.textLabel!.text = "      \(self.dataSource[parent].childs[indexPath.row - actualPosition - 1])"
            
            
            if isSubMain(cell.textLabel!.text!) {
                //cell.backgroundColor = UIColor.lightGrayColor()
            }
            
            // check label if parent or not
            //cell.backgroundColor = UIColor.lightGrayColor()
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier(parentCellIdentifier, forIndexPath: indexPath)
            cell.textLabel!.text = self.dataSource[parent].title
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let (parent, isParentCell, actualPosition) = self.findParent(indexPath.row)
        
        guard isParentCell else {
            NSLog("A child was tapped!!!")
            
            // The value of the child is indexPath.row - actualPosition - 1
            NSLog("The value of the child is \(self.dataSource[parent].childs[indexPath.row - actualPosition - 1])")
            
            Alert.show("Selected value", message: "\(self.dataSource[parent].childs[indexPath.row - actualPosition - 1])", vc: self)
            
        selectedNature = "\(self.dataSource[parent].childs[indexPath.row - actualPosition - 1])"
            
            print("Nature: \(selectedNature)")
            
            print("Nature 1: \(getNatureIds(selectedNature).0)")
            print("Nature 2: \(getNatureIds(selectedNature).1)")
            
            return
        }
        
        self.tableView.beginUpdates()
        self.updateCells(parent, index: indexPath.row)
        self.tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return !self.findParent(indexPath.row).isParentCell ? 44.0 : 64.0
    }



}
