//
//  ApiUtility.swift
//  ehss
//
//  Created by IOS1-PC on 28/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import Foundation


struct ApiUtility{
    
    static let sharedInstance = ApiUtility()
    
    func sendForm(let parameters:Dictionary<String,String>, let url:String, image:UIImage, vc:UIViewController){
        let apiUrl = NSURL(string: url)
        let request = NSMutableURLRequest(URL: apiUrl!)
        request.HTTPMethod = "POST"
        
        let param = parameters
        
        let boundary = generateBoundaryString()
        let img:UIImage = image
        
        request.setValue("multipart/form-data=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(img, 0.5)
        
        
        if imageData == nil {
            return;
        }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil {
                print("error = \(error)")
                return
            }else{
                Alert.show("Success", message: "Data has been saved!", vc: vc)
            }
            
            
            
        }
        
        task.resume()
        
    }
    
    
}

//Mark:-Utilities

extension ApiUtility{
    func generateBoundaryString()->String{
        return "Boundary-\(NSUUID().UUIDString)"
    }
}

//Mark:-Return Body Processes

extension ApiUtility{
    func createBodyWithParameters(parameters:[String:String]?, filePathKey:String?, imageDataKey:NSData,boundary:String)->NSData{
        let body = NSMutableData()
        let filename = "imageupload.jpg"
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition:form-data; name=\"\(filePathKey)\";filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type:\(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        if parameters != nil {
            for(key, value) in parameters!{
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString("\(value)\r\n")
            
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }

}

