//
//  hotSpotMapVC.swift
//  ehss
//
//  Created by IOS1-PC on 26/05/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit
import WebKit
import STZPopupView
import Kingfisher
import AlamofireImage
import Alamofire

import CoreData


var image:String = ""
var coordinates: String = ""


struct mlocation {
    var locationName:String = ""
    var locationAdd:String = ""
    var locationStat:String = ""
}

var main_location = ""
var main_address = ""
var main_stat = ""


class hotSpotMapVC: UIViewController,WKScriptMessageHandler {
    
    @IBOutlet weak var containerView: UIView!
 
    @IBOutlet weak var mnuListAll: UIBarButtonItem!
    @IBOutlet weak var headerView: UIView!
    
      
    var webView: WKWebView?
    
    override func loadView() {
        super.loadView()
        
        var img: UIImage?
        
         Alamofire.request(.GET, "https://support.apple.com/library/content/dam/edam/applecare/images/en_US/iphone/iphone-6s-colors.jpg").responseImage {
            response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            print(response.result)
            
            if let image = response.result.value {
                //print("image downloaded: \(image)")
                
                img = image
            }
        } 
 
      //  UIImageWriteToSavedPhotosAlbum(img!, self, "image:didFinishSavingWithError:contextInfo:",nil )
       
        
    
        
        let contentController = WKUserContentController();
        
        let userScript = WKUserScript(
            source: "redHeader()",
            injectionTime: WKUserScriptInjectionTime.AtDocumentEnd,
            forMainFrameOnly: true
        )
        contentController.addUserScript(userScript)
        
        let userScript2 = WKUserScript(
            source: "sendInfo",
            injectionTime: WKUserScriptInjectionTime.AtDocumentStart,
            forMainFrameOnly: true
        )
        
        contentController.addUserScript(userScript2)
        
        
        contentController.addScriptMessageHandler(
            self,
            name: "callbackHandler"
        )
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        self.webView = WKWebView(
            frame: self.containerView.bounds,
            configuration: config
        )
        
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            mnuListAll.target = revealViewController()
            mnuListAll.action = "revealToggle:"
            
            revealViewController().rightViewRevealWidth = 150
            // extraButton.target = revealViewController()
            //extraButton.action = "rightRevealToggle:"
            
            /*
             var url:NSURL = NSURL.URLWithString("http://myURL/ios8.png")
             var data:NSData = NSData.dataWithContentsOfURL(url, options: nil, error: nil)
             
             imageView.image = UIImage.imageWithData(data)
             */
            
            
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        
        //self.view = self.webView!
    }
    
    func hasBeenSavedInPhotoAlbumWithError(){
    }
    
    func getNetworkImage(urlString: String, completion: (UIImage? -> Void)) -> (Request){
        return Alamofire.request(.GET, urlString).responseImage{
            (response) -> Void in
            guard let image = response.result.value else {return}
            completion(image)
        }
    }
    
    
    func downloadImage(){
        
    }
    
    func loadImage(){
    
    }
    
    
    func getImageLocation(let imageId:Int) -> (l:String, a:String, s:String){
    
        var l = ""
        var a = ""
        var s = ""
        
        
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName:"Location")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@", "\(imageId)")
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            l = results[0].valueForKey("name") as! String
            a = results[0].valueForKey("address") as! String
            s = results[0].valueForKey("stat") as! String
        }
        
        
       return (l,a,s)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
       
        
        //Load all coordinates and get by parents
        
        
        let imageId: Int = 1
        
        image = "https://v3.ehss.net/mobile/getimagenew/username/aileenfernando@gmail.com/password/741852963/image/\(imageId)"
         main_location = getImageLocation(imageId).l
         main_address = getImageLocation(imageId).a
        
        let val:Int = 1
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName:"Location")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "parent = %@", "\(val)")
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            for res in results {
                let c:String = (res.valueForKey("coordinates") as? String)!
                
                let lc: Int = (res.valueForKey("id") as? Int)!
                
                coordinates += "<area shape='poly' coords='\(c)'  onclick='sendInfo(\(lc))' />"
                
               
            }
        }
        
        print("This coordinates: \(coordinates)")
        
        
   
        
        
        //coordinates = "<area shape='poly' coords='231,227,244,247,277,228,263,208'  onclick='sendInfo(\(imageId))' />"
        
        
        //gets coordinates in html
        //select * where parents is equal to
        
        
        
        
        let htmlString = "<!DOCTYPE html>  <html>" +
            "<head>" +
            "<style type='text/css'>" +
            "body {" +
            "" +
            "padding-top: 40px;" +
            "}" +
            "</style>" +
            "<title>WKWebView Demo</title>" +
            "<meta charset='UTF-8'>" +
            "<meta name='viewport' content='width=device-width; user-scalable=0;' />" +
            "</head>" +
            "<body >" +
            "<div style='width:100%; height:70px; background-color:#ffffff;'></div>" +
            "<div style='width:100%; height:150px; background-color:#42b842;'>" +
            "<div style='float:left;'><span style='color:#fffff;'>\(main_location)</span><br/>\(main_address)</div>" +
            "<div style='width:100px; height:100px; background-color:blue;float:right;'></div>" +
            "</div>" +
            "<img id='img_map' src='\(image)'  usemap='#ehssmap' />" +
            "<script type='text/javascript' src='main.js'></script>" +            "<map name='ehssmap'>" +
            "\(coordinates)" +
            "</map>" +
            "</body>" +
        "</html>";
               let path:NSString = NSBundle.mainBundle().bundlePath
        let baseURL: NSURL = NSURL(fileURLWithPath: path as String)        
        self.webView?.loadHTMLString(htmlString as String, baseURL: baseURL)
        self.view.addSubview(self.webView!)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userContentController(userContentController: WKUserContentController!, didReceiveScriptMessage message: WKScriptMessage!) {
        if(message.name == "callbackHandler") {
            
            print("Values:\(message.body)")
            
           
       
            
            let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
            let context: NSManagedObjectContext = AppDel.managedObjectContext!
            let request = NSFetchRequest(entityName:"Location")
            request.predicate = NSPredicate(format:"id = %@","\(message.body)")
            
            request.returnsObjectsAsFaults = false
            
            let results: NSArray = try! context.executeFetchRequest(request)
        
            if results.count > 0{
                let isMap:Int = results[0].valueForKey("is_map") as! Int
                let id:Int = results[0].valueForKey("id") as! Int
                let image:String = results[0].valueForKey("image") as! String
                let statistics:String = results[0].valueForKey("stat") as! String
                let n:String = results[0].valueForKey("name") as! String
                
                print("ismap: \(isMap)")
                print("id: \(id)");
                print("image name: \(image)");
                
                
                /*
                 let fullName = "First Last"
                 let fullNameArr = fullName.characters.split{$0 == " "}.map(String.init)
                 // or simply:
                 // let fullNameArr = fullName.characters.split{" "}.map(String.init)
                 
                 fullNameArr[0] // First
                 fullNameArr[1] // Last
                 */
                
                let allStat = statistics.characters.split{$0 == ","}.map(String.init)
                
                
                if(isMap == 1){
                    loadPopupStat(id)
                }else{
                    let alert = UIAlertController(title: "", message: "\(n): \n \(allStat[0]) Incident(s) \n \(allStat[1]) Hazard(s) \n \(allStat[2]) Nonconformance(s)", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            }

            
            
            /*
            if message.body as! String == "2"{
             
            }else{
                print("nothing loaded!")
            }*/
            
            
            
            
        }
    }
    
    func loadPopupStat(let id:Int){
        
        /*
        let myview = PopupCustomView(frame: CGRect(x:100, y:100,width:250, height:250))
        
        myview.backgroundColor = UIColor.whiteColor()
        myview.layer.cornerRadius = 25
        
        
        let popupView = myview
        presentPopupView(popupView) */
        
        var coord:String = ""
         
         // Do any additional setup after loading the view.
        
        let imageId: Int = 3
         
         image = "https://v3.ehss.net/mobile/getimagenew/username/aileenfernando@gmail.com/password/741852963/image/\(id)"
        
        let val:Int = id
        
        main_location = getImageLocation(id).l
        main_address = getImageLocation(id).a
        
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName:"Location")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "parent = %@", "\(val)")
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            for res in results {
                let c:String = (res.valueForKey("coordinates") as? String)!
                
                let lc: Int = (res.valueForKey("id") as? Int)!
                
                coord += "<area shape='poly' coords='\(c)'  onclick='sendInfo(\(lc))' />"
                
                
            }
        }
        
        
        //regenerate coordinates
        //coordinates = "231,227,244,247,277,228,263,208"
       
         
         let htmlString = "<!DOCTYPE html>  <html>" +
         "<head>" +
         "<style type='text/css'>" +
         "body {" +
         "" +
         "padding-top: 40px;" +
         "}" +
         "</style>" +
         "<title>WKWebView Demo</title>" +
         "<meta charset='UTF-8'>" +
         "<meta name='viewport' content='width=device-width; user-scalable=0;' />" +
         "</head>" +
         "<body >" +
         "<div style='width:100%; height:70px; background-color:#ffffff;'></div>" +
         "<div style='width:100%; height:150px; background-color:#42b842;'>" +
         "<div style='float:left;'><span style='color:#fffff;'>\(main_location)</span><br/> \(main_address)</div>" +
         "<div style='width:100px; height:100px; background-color:blue;float:right;'></div>" +
         "</div>" +
         "<img id='img_map' src='\(image)'  usemap='#ehssmap' />" +
         "<script type='text/javascript' src='main.js'></script>" +            "<map name='ehssmap'>" +
         "\(coord)" +
         "</map>" +
         "</body>" +
         "</html>";
         let path:NSString = NSBundle.mainBundle().bundlePath
         let baseURL: NSURL = NSURL(fileURLWithPath: path as String)
         self.webView?.loadHTMLString(htmlString as String, baseURL: baseURL)
        
        
      
    }
    
    func getParent(let id:Int) -> Int{
        
        var parent:Int = 0
    
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName:"Location")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        let results:NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            parent = results[0].valueForKey("parent") as! Int
            
        }
        
        print("Parent: \(parent)")
        
        return parent
    }
    
    func otherInfo(){
        /*
         request = NSFetchRequest(entityName:"Location")
         request.returnsObjectsAsFaults = false
         request.predicate = NSPredicate(format: "id = %@", "\(imageId)")
         
         let r:NSArray = try! context.executeFetchRequest(request)
         
         if r.count > 0 {
         location = r[0].valueForKey("namme") as! String
         address = r[0].valueForKey("address") as! String
         stat = r[0].valueForKey("stat") as! String
         }
         
         */
    }



}
