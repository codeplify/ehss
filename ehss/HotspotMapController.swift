//
//  HotspotMapController.swift
//  ehss
//
//  Created by IOS1-PC on 07/06/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class HotspotMapController: UIViewController {
    @IBOutlet weak var imgView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let url = NSURL(string: "https://v3.ehss.net/mobile/getimagenew/username/aileenfernando@gmail.com/password/741852963/image/1")
        
        imgView.af_setImageWithURL(url!, placeholderImage: UIImage(named: "load1.gif"), filter: nil, progress: nil, imageTransition: .CrossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)

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
