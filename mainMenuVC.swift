//
//  mainMenuVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/16/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit

class mainMenuVC: UITableViewController{

    var menuList:[menuItem] = [menuItem]()
    
    struct menuItem{
        var menuIcon: String
        var menuTitle: String
    }
    
    
    //@IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let menu1 = menuItem(menuIcon: "ic_dashboard_black_24dp", menuTitle: "Dashboard")
        let menu2 = menuItem(menuIcon: "ic_riskmatrix_black_24dp", menuTitle: "Risk Matrix")
        let menu3 = menuItem(menuIcon: "ic_place_black_24dp", menuTitle: "Hot Spot")
        let menu4 = menuItem(menuIcon: "ic_severity_black_24dp", menuTitle: "Incident Severity")
        let menu5 = menuItem(menuIcon: "ic_equalizer_black_24dp", menuTitle: "Summary")
        let menu6 = menuItem(menuIcon: "ic_data_usage_black_24dp", menuTitle: "Content Manager")
        let menu7 = menuItem(menuIcon: "ic_description_black_24dp", menuTitle: "Notification List")
        let menu8 = menuItem(menuIcon: "ic_note_add_black_24dp", menuTitle: "Hazard List")
        let menu9 = menuItem(menuIcon: "ic_auditinspect_black_24dp", menuTitle: "Audit Inspection List")
        let menu10 = menuItem(menuIcon: "ic_arrow_back_black_24dp", menuTitle: "Log out")
        
        
        //menuList.append(menu1)
        //menuList.append(menu2)
        //menuList.append(menu3)
        //menuList.append(menu4)
        //menuList.append(menu5)
        //menuList.append(menu6)
        //menuList.append(menu7)
        //menuList.append(menu8)
        //menuList.append(menu9)
        //menuList.append(menu10)
        
        for m in menuList{
            //print("Menu Title:\(m.menuTitle)")
        }
        
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("Count: \(menuList.count)")
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return menuList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dCell",forIndexPath: indexPath) as! dashboardMenuCell
        
        
        let menu:menuItem = menuList[indexPath.row]
        
        print(indexPath.row)
        
        cell.mnuTitle.text = menu.menuTitle
        cell.imgViewMnuIcon.image = UIImage(named: "\(menu.menuIcon).png")
        
        //print(menu.menuTitle)
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let selected = menuList[indexPath.row]
        
        if indexPath.row == 10 {
            
    
        }
        
      
        
        
    }
    
    
    
    
    /*
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
     print("Selected : \(natureList[indexPath.row])")
     
     let incidentNat:IncidentNatVC = self.storyboard?.instantiateViewControllerWithIdentifier("incidentNat") as! IncidentNatVC
     
     incidentNat.selectedNatureCat = natureList[indexPath.row]
     
     self.presentViewController(incidentNat, animated: true, completion: nil)
     }

     */


    /*
     
     
     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
     // #warning Potentially incomplete method implementation.
     // Return the number of sections.
     return incidentList.count
     }
     
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // #warning Incomplete method implementation.
     // Return the number of rows in the section.
     return 1
     }
     
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("incidentCell", forIndexPath: indexPath) as! incidentListCell
     
     let h:incident = incidentList[indexPath.row]
     
     cell.lblLocation.text = getLocationName(h.location) as String
     cell.lblName.text = h.name
     
     
     return cell
     }

     */

}
