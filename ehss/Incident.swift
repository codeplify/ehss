//
//  Incident.swift
//  ehss
//
//  Created by IOS1-PC on 16/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import Foundation

struct Incident{

    /*
     var date: String
     var time: String
     var location: Int
     var company: Int
     var department: Int
     var activity: String
     var description: String
     var userId:Int
     var user:String
     var password: String
     var nature:Int
     var nature_category: Int
     var image: String
     
     
     */
    var userId:Int?
    var date:String?
    var time:String?
    var companyId:Int?
    var departmentId:Int?
    var activity:String?
    var description:String?
    var natureId:Int?
    var imageAttachment:String?
    var location:Int?
    var natureCategory:Int?
    var image:String?
    
    init(userId:Int, date:String, time:String, companyId:Int, departmentId:Int, activity:String, description: String,
         natureId:Int,location:Int,natureCat:Int, image:String){
        self.date = date
        self.time = time
        self.activity = activity
        self.userId = userId
        self.companyId = companyId
        self.departmentId = departmentId
        self.activity = activity
        self.description = description
        self.natureId = natureId
        self.location = location
        self.natureCategory = natureCat
        self.imageAttachment = image
    }
}