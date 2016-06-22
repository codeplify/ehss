//
//  CommonUtils.swift
//  ehss
//
//  Created by IOS1-PC on 22/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import Foundation
import CoreData


class CommonUtils:NSObject {

    static let sharedInstance = CommonUtils()
    
    func currentDate()->String{
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        return "\(dateFormatter.stringFromDate(date))"
    }
    
    func currentTime() -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .NoStyle
        dateFormatter.timeStyle = .MediumStyle
        
        return "\(dateFormatter.stringFromDate(date))"
    }
    
    /*
     
     let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
     let context: NSManagedObjectContext = AppDel.managedObjectContext!
     let request = NSFetchRequest(entityName: "AllUser")
     request.returnsObjectsAsFaults = false
     
     request.predicate = NSPredicate(format: "email = %@", userPref.valueForKey("ehss_username") as! String)
     
     
     
     do{
     
     let result:NSArray = try context.executeFetchRequest(request)
     
     //print("username count : \(result.count)")
     
     if result.count > 0 {
     let r = result[0] as! NSManagedObject
     
     lblUserFull.text = r.valueForKey("name") as? String
     
     //print("username \(lblUserFull.text)")
     }
     
     }catch{
     
     }

     */
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    func currentUser()-> String{
        
        var ret = ""
        
        if(userDefaults.objectForKey("ehss_username") != nil ){
            let uname = userDefaults.valueForKey("ehss_username") as! String
            
            let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            let context : NSManagedObjectContext = AppDel.managedObjectContext!
            let request = NSFetchRequest(entityName: "AllUser")
            
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "email = %@", "\(uname)")
            
            do{
                let result: NSArray = try context.executeFetchRequest(request)
                if result.count > 0 {
                    
                    let res = result[0] as! NSManagedObject
                    
                    ret = res.valueForKey("name") as! String
                
                }
                
                
            }catch {
                //print("\(error)")
                ret = "Unknown"
            }
            
            
        }else{
            ret = "Undefined!"
        }
        
        return ret
    }
    
    
    
    
}