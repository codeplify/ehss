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
    

    func getDomain()->String{
        
        var subdomain = ""
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Usercontroller")
        
        request.returnsObjectsAsFaults = false
        
        do{
            let result:NSArray = try context.executeFetchRequest(request)
            if result.count > 0 {
                let res = result[0] as! NSManagedObject
                subdomain = res.valueForKey("subdomain") as! String
            }
        }catch{
            subdomain = ""
        }
        
        return subdomain
    }
    
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
    
    func currentPassword()->String{
        var ret = ""
        
        if(userDefaults.objectForKey("ehss_username") != nil){
            let password = userDefaults.valueForKey("ehss_password")
            
            ret = password as! String
        }
        
        return ret
    }
    
    func emailAddress()->String{
        if(userDefaults.objectForKey("ehss_username") != nil){
            let email = userDefaults.valueForKey("ehss_username")
            return email as! String
            
        }else{
            return ""
        }
    
    }
    
    
    
    
    
}