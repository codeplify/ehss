//
//  CoreDataUtility.swift
//  ehss
//
//  Created by IOS1-PC on 21/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit
import CoreData

class CoreDataUtility: NSObject {
    
    static let sharedInstance = CoreDataUtility()
    
    
    static func instantiateContext() ->NSManagedObjectContext{
        let applicationDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = applicationDelegate.managedObjectContext!
        
        return context
        
    }
    
    
    static func getHazard(id:Int) -> hazardVC.Hazard{
        
        
        
        var hazard:hazardVC.Hazard? = nil
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Hazard")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do{
            let result:NSArray = try context.executeFetchRequest(request)
            
            if result.count > 0 {
                
                let description = result[0].valueForKey("desc") as! String
                
                hazard!.hazardDescription = description
            
            }
        
        
        }catch {
        
        }
        
        return hazard!
    
    }
    
    static func getUserId(let username:String)-> Int{
        
        var userId:Int = 0
        
        let context = instantiateContext()
        let request = NSFetchRequest(entityName: "AllUser")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "email = %@", "\(username)")
        
        do{
            let result:NSArray = try context.executeFetchRequest(request)
            
            if result.count > 0 {
                userId = result[0].valueForKey("id") as! Int
            }
        }catch{
            userId = 0
        }
        
        
        
        return userId
    }
    
    
    static func getCompany(let id: Int)->String{
        
        
        var company:String = ""
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Milestone")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@","\(id)")
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            company = res.valueForKey("company") as! String
        }else{
            print("Error find company", terminator: "")
            
            
            print("company = \(id)")
        }
        return company
    }
    
    static func getDepartment(let id: Int)->String{
        var department = ""
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context:NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Unit")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            department = res.valueForKey("name") as! String
        }else{
        
        }
        
        return department
    }
    
    static func getHazardType(let id: Int) ->String{
        
        var strType = ""
        
        let c:NSManagedObjectContext = instantiateContext()
        
        let request = NSFetchRequest(entityName: "Preferences")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "id = %@", "\(id)")
        let results:NSArray = try!c.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            strType = res.valueForKey("preference") as! String
        }
        
        return strType
        
    }
    
    static func getHazardImpact(let id: Int)->String{
        var hazardImpact = ""
        
        let c:NSManagedObjectContext = instantiateContext()
        let request = NSFetchRequest(entityName: "HazardOrigin")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        
        let results:NSArray = try! c.executeFetchRequest(request)
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            hazardImpact = res.valueForKey("origin") as! String
        }
        
        return hazardImpact
    
    }
    
   
    
    func updateSync(id:Int, entity:String, comparator:String)->Bool{
        var isSync:Bool = false
        
        let c:NSManagedObjectContext = CoreDataUtility.instantiateContext()
        let request = NSFetchRequest(entityName: "\(entity)")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "\(comparator) = %@", "\(id)")
        
        let results: NSArray = try! c.executeFetchRequest(request)
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            
            res.setValue(1, forKey: "is_sync")
            
            do{
                try res.managedObjectContext?.save()
                isSync = true
                
            }catch let error as NSError{
                print("\(error)")
                
                isSync = false
            }
            
        }
        
        
        return isSync
    }
    
    static func isSync(id:Int, entity: String, comparator: String) -> Bool{
        
        var isSync:Bool?
        
        let c:NSManagedObjectContext = instantiateContext()
        let request = NSFetchRequest(entityName: entity)
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "\(comparator) = %@", "\(id)")
        
        let results:NSArray = try! c.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            let valueIsSync = res.valueForKey("is_sync") as! Int
            if valueIsSync == 1 {
                isSync = true
            }else{
                isSync = false
            }
            
           
        }
        
        return isSync!
        
    }
    
    static func getLocation(let id:Int) -> String{
        
        var location = String()
        
        let c:NSManagedObjectContext = instantiateContext()
        let request = NSFetchRequest(entityName: "Location")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        let results:NSArray = try! c.executeFetchRequest(request)
        
        if results.count > 0 {
            let res = results[0] as! NSManagedObject
            location  = res.valueForKey("name") as! String
        }
        
        
        return location
    }
    


    static func getIncrementedId() -> Int{
        
        let ret: Int  = 0
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "Hazard")
        
        
        request.returnsObjectsAsFaults = false
        
        var num:[Int] = [Int]()
        
        do {
            let result:NSArray = try context.executeFetchRequest(request)
            
            if result.count > 0 {
                
                for r in result {
                    
                    let j:Int = r.valueForKey("id") as! Int
                    
                    num.append(j)
                }
                
            }else {
                return ret + 1
            }
        } catch let error as NSError {
           print("Alert: \(error)")
        }
        
       return num.maxElement()! + 1
      }
}

