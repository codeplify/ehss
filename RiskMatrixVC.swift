//
//  RiskMatrixVC.swift
//  ehss
//
//  Created by IOS1-PC on 26/05/2016.
//  Copyright © 2016 AgdanL. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class RiskMatrixVC: UIViewController {

    @IBOutlet weak var mnuListAll: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    
    
    struct  riskMatrixLegend {
        var id:Int
        var count:Int
        var legend:String
        var color:String
        
        
    }
    
    
    struct matrixValueColor {
        var scale:Int
        var row:Int
        var column:Int
    }
    
    struct matrixScoreValue {
        var id: Int
        var scale:String
        var value: String
    }
    
    
    
    var legend:[riskMatrixLegend] = [riskMatrixLegend]()
    var colorDes:[matrixValueColor] = [matrixValueColor]()
    

    
    func loadLegend(){
        
        let AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "RiskMatrixLegend")
        
        request.returnsObjectsAsFaults = false
        
        let results: NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            
            for i in results {
                
                let id = i.valueForKey("id") as! Int
                let count = i.valueForKey("count") as! Int
                let scale = i.valueForKey("scale") as! String
                let color = i.valueForKey("color") as! String
                
                
                
                let l: riskMatrixLegend = riskMatrixLegend(id: id, count: count, legend: scale, color: color)
                
                legend.append(l)
                
                //legend.append()
            }
        
        }
        
    }
    
    func loadValue(){
        let AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "RiskMatrixValue")
        
        request.returnsObjectsAsFaults = false
        
        let results: NSArray = try! context.executeFetchRequest(request)
        
        
        if results.count > 0 {
            for i in results {
                let scale: Int = i.valueForKey("scale") as! Int
                let column: Int = i.valueForKey("column") as! Int
                let row: Int = i.valueForKey("row") as! Int
                
                
                let c: matrixValueColor = matrixValueColor(scale: scale, row: row, column: column)
                
                colorDes.append(c)
                
            }
        }
    }
    
    func loadScoreValue()-> matrixScoreValue{
        
        var msValue:matrixScoreValue = matrixScoreValue(id: 0, scale: "", value: "")
        
        let AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "RiskMatrixScore")
        
        request.returnsObjectsAsFaults = false
        
        let results: NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            //for i in results {
                let id:Int = results[0].valueForKey("id") as! Int
                let value:String = results[0].valueForKey("value") as! String
                let scale:String = results[0].valueForKey("scale") as! String
                
                msValue = matrixScoreValue(id: id, scale: scale, value: value)
                
            //}
        }
        
        return msValue
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadLegend()
        //loadValue()
        
        
        
        let legend1 = riskMatrixLegend(id: 2, count: 0, legend: "Low", color: "#507322")
        let legend2 = riskMatrixLegend(id: 3, count: 1, legend: "High", color: "#c51c1a")
        let legend3 = riskMatrixLegend(id: 4, count: 0, legend: "Medium", color: "#f5d524")
        
        legend.append(legend1)
        legend.append(legend2)
        legend.append(legend3)
        
        let cellColor1 = matrixValueColor(scale: 3, row: 1, column: 1)
        let cellColor2 = matrixValueColor(scale: 3, row: 1, column: 2)
        let cellColor3 = matrixValueColor(scale: 2, row: 1, column: 3)
        let cellColor4 = matrixValueColor(scale: 2, row: 1, column: 4)
        let cellColor5 = matrixValueColor(scale: 2, row: 1, column: 5)
        let cellColor6 = matrixValueColor(scale: 4, row: 2, column: 1)
        let cellColor7 = matrixValueColor(scale: 3, row: 2, column: 2)
        let cellColor8 = matrixValueColor(scale: 3, row: 2, column: 3)
        let cellColor9 = matrixValueColor(scale: 2, row: 2, column: 4)
        let cellColor10 = matrixValueColor(scale: 2, row: 2, column: 5)
        
        colorDes.append(cellColor1)
        colorDes.append(cellColor2)
        colorDes.append(cellColor3)
        colorDes.append(cellColor4)
        colorDes.append(cellColor5)
        colorDes.append(cellColor6)
        colorDes.append(cellColor7)
        colorDes.append(cellColor8)
        colorDes.append(cellColor9)
        colorDes.append(cellColor10)
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            mnuListAll.target = revealViewController()
            mnuListAll.action = "revealToggle:"
            
            revealViewController().rightViewRevealWidth = 150
           
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        var mt:String = ""
        
 
        
        let xAxis:[String] = ["Catastrophic","Major","Moderate","Minor","Insignificant"]
        let yAxis:[String] = ["Remote","Unlikely","Possible","Likely","Most Likely"]
        
        mt = "<tr><td style='background-color:#d3d3d3;'>&nbsp;</td>"
        
        for y in yAxis{
            mt = mt + "<td style='background-color:#d3d3d3;'>\(y)</td>"
        }
        
        mt = mt + "</tr>"
        
        var xi = 0
        
        
        for x in xAxis{
            
            xi += 1
            var yi = 0
            
           mt = mt + "<tr>"
            
            mt = mt + "<td style='background-color:#d3d3d3;'>\(x)</td>"
            for y in yAxis{
                
                yi += 1
               
               //var rc = "\(xi),\(yi): "
                
               mt = mt + "<td style='text-align:center;background-color:\(getColor(xi, col: yi));'>\(getMatrixValue(xi, column: yi))</td>"
                
                
                /*for z in colorDes{
                    if z.row == xi && z.column == yi {
                         mt = mt + "<td style='text-align:center;background-color:yellow;'>\(z.scale)</td>"
                    }else{
                        mt = mt + "<td style='text-align:center;background-color:yellow;'>\(xi),\(yi)</td>"
                    }
                } */
                
                
            }
            
            mt = mt + "</tr>"
            
        }
        
        let matrixTable:String = "<table style='border:1px solid #000000;border-collapse:collapse;' border=1 >" +
            mt +
            "</tr>" +            
        "</table>"
        
        
        var ls:String = "<tr>"
        
        for z in legend{
            ls = ls + "<td><div style='width:10px;height:10px;background-color:\(z.color)'></div>\(z.count)   \(z.legend) </td>"
        }
        
        ls = ls + "</tr>"
        
        
        let legendHtml:String = "<table>\(ls)</table>"
        
        let htmlString = "<html><head><title></title></head><body style='font-family:arial;'>\(matrixTable)<br/>\(legendHtml)</body></html>"
        
        webView.scrollView.scrollEnabled = true
        
        webView.loadHTMLString(htmlString as String, baseURL: nil)
        
        
    }
    
    func getColor(let row:Int, let col:Int)-> String {
        
        var colorValue:String = ""
        
        for i in colorDes {
            if row == i.row && col == i.column {
                colorValue = "\(getColorValue(i.scale))"
            }
        }
        
        return colorValue
    }
    
    func getColorValue(let id: Int)->String{
        
        var hexColor:String = ""
        
        for y in legend{
            if y.id == id {
                hexColor = y.color
            }
        }
        
        return hexColor
    }
    
    
    func getMatrixValue(let row:Int, let column:Int) -> Int{
        
        var ret = 0;
        
        
        let score: matrixScoreValue = loadScoreValue()
            //let allStat = statistics.characters.split{$0 == ","}.map(String.init)
        let allScore = score.value.characters.split{$0 == ","}.map(String.init)
            //get row and column of the id
        
        for j in allScore {
            let idVal = j.characters.split{$0 == ":"}.map(String.init)
            
            let r = riskMatrixValue2(Int(idVal[0])!)
            
            if r.c == column && r.r == row {
                ret = Int(idVal[1])!
            }else{
                ret = 0
            }
            
        }
        return ret
    }
    
    func riskMatrixValue2(let id: Int) ->(r:Int, c:Int){
        let AppDel: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "RiskMatrixValue")
        
        var row:Int = 0
        var col:Int = 0
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        let results: NSArray = try! context.executeFetchRequest(request)
        
        if results.count > 0 {
            //for i in results {
            //let id:Int = results[0].valueForKey("id") as! Int
            row = results[0].valueForKey("row") as! Int
            col = results[0].valueForKey("column") as! Int
            
        }
        
        return (row, col)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

}
