//
//  IncidentTabController.swift
//  ehss
//
//  Created by IOS1-PC on 16/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit

class IncidentTabController: UITabBarController ,UITabBarControllerDelegate{

    var strPassedValue:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

}
