//
//  IncidentSeverityVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/10/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import Charts
import CoreData

class IncidentSeverityVC: UIViewController {
    
    
 
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var btnMenuList: UIBarButtonItem!
    
    struct severityValue {
        var cla:String
        var val:Double
        var col:UIColor
    }
    
    var sevValueList:[severityValue] = [severityValue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            btnMenuList.target = self.revealViewController()
            btnMenuList.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let c: [UIColor] = [UIColor.cyanColor(),UIColor.redColor(),UIColor.greenColor(), UIColor.yellowColor(), UIColor.brownColor()]
        
        var classChart:[String] = [String]()
        
               var cv:[Double] = []
        let AppDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = AppDel.managedObjectContext!
        let request = NSFetchRequest(entityName: "GraphData")
        
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "chart = %@", "severity")
        
        
        do {
            
            let result:NSArray = try context.executeFetchRequest(request)
            
            if result.count>0 {
                    let chartValue = result[0].valueForKey("value1") as! String
                
                    let valArr = chartValue.componentsSeparatedByString(",")
                
                for (i,e) in valArr.enumerate(){
                        var x = i
                        x = x + 1
                    
                    
                     cv.append(Double(e)!)
                    
                    if Double(e)! == 0.0 {
                        
                    }else{
                        classChart.append("Class \(x)")
                    }
                }
            }
            
        }catch{
        
        }
        
        /*do {
         
            if result.count>0 {
                for i in result {
                    
                    let id:Int = i.valueForKey("id") as! Int
                    let chart:String = i.valueForKey("chart") as! String
                    let value1: String = i.valueForKey("value1") as! String
                    let value2: String = i.valueForKey("value2") as! String
                    
                    print("id: \(id), chart: \(chart), value1: \(value1), value2: \(value2)")
                    
                    if chart == "severity" {
                        let values = value1.componentsSeparatedByString(",")
                        
                    }
                    
                }
            }
            
        }catch{
        
        } */
       
        //let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0]
        
        setChart(classChart, values: cv)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        //var colors: [UIColor] = []
        
        //let colors: [UIColor] = [UIColor.redColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.yellowColor(), UIColor.brownColor()]
        
        let colors: [UIColor] = [UIColor.cyanColor(),UIColor.redColor(),UIColor.greenColor(), UIColor.yellowColor(), UIColor.brownColor()]
        
        /*for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }*/
        
        pieChartDataSet.colors = colors
        
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
