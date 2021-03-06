//
//  AccordionMenuTableViewController.swift
//  ehss
//
//  Created by IOS1-PC on 15/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

/*******************
 *
 * Add image value to send that will be passed by first tab
 *
 ***************************/

import UIKit
import CoreData


// MARK:- Global Declaration
var userPref = NSUserDefaults()
var username = ""
var password = ""
var subdomain = ""

class AccordionMenuTableViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,IncidentDelegate{
    
    
    // MARK:- Incident Variables
    var incident : Incident? = nil
    var imgPassedValue = UIImage()
    var selectedNature = ""
    var parentMenu:[String] = ["Safety","Environment","Health","Security"]
    let commonUtil:CommonUtils = CommonUtils.sharedInstance
    
    var imagesDirectoryPath:String!

    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK:- Save to SQLiteDB
    @IBAction func btnSubmitAction(sender: UIButton) {
        
        //save first
        if userPref.valueForKey("ehss_username") != nil && userPref.valueForKey("ehss_password") != nil && userPref.valueForKey("subdomain") != nil {
        
            username = userPref.valueForKey("ehss_username") as! String
            password = userPref.valueForKey("ehss_password") as! String
            subdomain = userPref.valueForKey("subdomain") as! String
           
        }
        
        
        
        /*
         save image location in core data
         
         let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
         // self.fileName is whatever the filename that you need to append to base directory here.
         let path = documentsDirectory.stringByAppendingPathComponent(self.fileName)
         let success = data.writeToFile(path, atomically: true)
         if !success { // handle error }
         */
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let newIncident = NSEntityDescription.insertNewObjectForEntityForName("Noi", inManagedObjectContext: context)
        let getNatureVar = getNatureIds(selectedNature)
        if(incident != nil){
            
            let currentFilename = "\(NSUUID().UUIDString).jpg"
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentDirectoryPath:String = paths[0]
            imagesDirectoryPath = documentDirectoryPath.stringByAppendingString("/Ehss")
            
            let fullPath = "\(imagesDirectoryPath)/\(currentFilename)"
            if let data = UIImageJPEGRepresentation(imgPassedValue, 0.5){
                let success = NSFileManager.defaultManager().createFileAtPath(imagesDirectoryPath, contents: data, attributes: nil)
                print("\(success)save image success Path:=> \(fullPath)")
            }else{
                print("error creating image")
            }
            
            print("current file name \(currentFilename)")
            
            //generate id
            newIncident.setValue(CoreDataUtility.getIncrementedId("Noi"), forKey: "id")
            newIncident.setValue(incident!.departmentId!, forKey: "department")
            newIncident.setValue(incident!.description!, forKey: "desc")
            newIncident.setValue(getNatureVar.0, forKey:"nature")
            newIncident.setValue(getNatureVar.1, forKey: "nature_category")
            newIncident.setValue(incident!.time!, forKey: "time")
            newIncident.setValue(incident!.date!, forKey: "date")
            newIncident.setValue("\(currentFilename)", forKey: "image")
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
        
       /*
        
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
        
        */
        
        // MARK: Declaration incident to send!
        
        let inc:Incident = Incident(userId: CoreDataUtility.getUserId(username), date: incident!.date!, time: incident!.time!, companyId: incident!.companyId!, departmentId: incident!.departmentId!, activity: incident!.activity!, description: incident!.description!, natureId: getNatureVar.0, location: incident!.location!, natureCat: getNatureVar.1, image: "")
        
        
        //passed string data
        print(inc.activity)
        
        
        requestMultipartForm(inc, image: imgPassedValue)
        
        print("mutipart form has been called!")
        
       //saveOnline(inc)
        print("<=======>")
    }
    
    
    //MARK:- Create Directory for INciddents
    func createFolder(){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectoryPath:String = paths[0]
        imagesDirectoryPath = documentDirectoryPath.stringByAppendingString("/Ehss")
        var objCBool:ObjCBool = true
        
        let isExist = NSFileManager.defaultManager().fileExistsAtPath(imagesDirectoryPath,isDirectory: &objCBool)
        
        if isExist == false {
            do{
                try NSFileManager.defaultManager().createDirectoryAtPath(imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                print("folder created ")
            }catch{
            
            }
        }else{
            print("something went wrong while creating folder for incident")
        }
    }
    
    
    //MARK:- Save to online json string
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
        
        /*
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
        } */
        
    }
    
    //Mark: Delegate
    func incidentCarrier(incident: Incident) {
        
        print("Incident : \(incident.activity)")
    }
    
    
    
    //MARK: Collapsable table view in nature generated
    
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
        
        
        createFolder()
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
    
    
    // MARK:- Generate LIST of NATURE
    
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
    
    
//MARK:- parts of collapsible table view 1
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



extension AccordionMenuTableViewController{
    
    func requestMultipartForm( incident:Incident , image:UIImage){
        let cutil:CommonUtils = CommonUtils.sharedInstance
        ///mobile/ios/save_noi
        let myURL = NSURL(string: "https://\(cutil.getDomain()).ehss.net/mobile/ios/save_noi")
        
        print("https://\(cutil.getDomain()).ehss.net/mobile/ios/save_noi")
        
        let request = NSMutableURLRequest(URL: myURL!)
        request.HTTPMethod = "POST"
        
        
        /*
         
         $n->notifier_id = $user_id;
         $n->notifier_name = Helper::cleanName($notifier->name);
         $n->notifier_company = $notifier->company;
         $n->notifier_department = $notifier->department;
         $n->notifier_section = $notifier->section;
         $n->notifier_designation = $notifier->designation;
         $n->notifier_home_phone = $notifier->home_phone;
         $n->notifier_mobile_phone = $notifier->mobile_phone;
         
         $n->department_id = $department;
         $n->company_id = $company;
         $n->description = $description;
         $n->nature_id = $nature_id;
         $n->nature_category = $nature;
         $n->occurence_date = Helper::dateFormat(strtotime($date));
         $n->location_id = $location;
         $n->activity = $activity;
         $n->occurence_time = Helper::militaryTime($time);
         $n->notification_code = $uid;
         
       */
        
        
        let username:String = cutil.emailAddress()
        let password:String = cutil.currentPassword()
        
        let param = [
            "department":"\(incident.departmentId!)",
            "description":"\(incident.description!)",
            "nature":"\(incident.natureId!)",
            "nature_category":"\(incident.natureCategory!)",
            "time":"\(incident.time!)",
            "date":"\(incident.date!)",
            "location":"\(incident.location!)",
            "activity":"\(incident.activity!)",
            "user_id":"\(incident.userId!)",
            "company_id":"\(incident.companyId!)",
            "username":"\(username)",
            "password":"\(password)"
        ]
        
        let boundary = generateBoundaryString()
        let img:UIImage = UIImage()
        
        
        for (key, value) in param{
            print("\(key):\(value)")
        }
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        if imageData == nil {return;}
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
               
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request)
        {
            data, response,error in
            
            print("Task started =====>")
            
            if error != nil {
                print("error = \(error)")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("response = > \(responseString)")
        }
        
        task2.resume()
    }
    
    func createBodyWithParameters(parameters:[String:String]?, filePathKey:String!, imageDataKey:NSData, boundary:String)->NSData{
    
            let body = NSMutableData()
            let filename = "test.jpg"
            let mimetype = "image/jpg"
        
            body.appendStringData("--\(boundary)\r\n")
            body.appendStringData("Content-Disposition:form-data; name=\"\(filePathKey!)\";filename=\"\(filename)\"\r\n")
            body.appendStringData("Content-Type:\(mimetype)\r\n\r\n")
            body.appendData(imageDataKey)
            body.appendStringData("\r\n")
        
        
            print("--\(boundary)\r\n")
            print("Content-Disposition:form-data; name=\"\(filePathKey!)\";filename=\"\(filename)\"\r\n")
            print("Content-Type:\(mimetype)\r\n\r\n")
            print("Content-Type:\(mimetype)\r\n\r\n")
            print("\(imageDataKey)")
            print("\r\n")
        
        if parameters != nil {
            for(key, value) in parameters!{
                body.appendStringData("--\(boundary)\r\n")
                body.appendStringData("Content-Disposition:form-data; name=\"\(key)\"")
                body.appendStringData("\(value)\r\n")
                
                
                print("--\(boundary)\r\n")
                print("Content-Disposition:form-data; name=\"\(key)\"")
                print("\(value)\r\n")
            }
        }
        
        body.appendString("--\(boundary)\r\n")
        
        return body
    }
    
    func generateBoundaryString()->String{
        return "Boundary-\(NSUUID().UUIDString)"
    }

}


 extension NSMutableData{
    func appendStringData(string: String){
            let data = string.dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: true)
        appendData(data!)
    }
 }
 


