//
//  Alert.swift
//  ehss
//
//  Created by IOS1-PC on 21/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit

class Alert: NSObject {
    
    static func show(title:String , message: String , vc: UIViewController){
        
        
        let alertCT = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAc = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert:UIAlertAction) in
            alertCT.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertCT.addAction(okAc)
        vc.presentViewController(alertCT,animated: true,completion: nil)
        
    }

}
