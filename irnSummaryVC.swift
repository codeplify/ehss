//
//  irnSummaryVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/10/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import Charts

class irnSummaryVC: UIViewController {

    @IBOutlet weak var segmentedTab: UISegmentedControl!
    @IBOutlet weak var barChartSummary: BarChartView!
  
    @IBOutlet weak var mnuList: UIBarButtonItem!
    var months:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.revealViewController() != nil {
            
            mnuList.target = self.revealViewController()
            mnuList.action = "revealToggle:"
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        months = ["Jan", "Feb", "Mar","April","May","June","July","August","Sep","Oct","Nov","Dec"]
        let unitsSold = [100.0, 20.0, 5.0,100.0, 20.0, 5.0,100.0, 20.0, 5.0,100.0, 20.0, 5.0]
        
        setChart(months, values: unitsSold)       }

    override func didReceiveMemoryWarning() {
        }
    @IBAction func segmentedControlAction(sender: UISegmentedControl) {
        
        
        if(segmentedTab.selectedSegmentIndex == 0)
        {
            months = ["Jan", "Feb", "Mar","April","May","June","July","August","Sep","Oct","Nov","Dec"]
            let unitsSold = [0.0, 0.0, 0.0,0.0, 0.0, 0.0,1.0, 0.0, 0.0,0.0, 0.0, 0.0]
            
            setChart(months, values: unitsSold)
        }
        else if(segmentedTab.selectedSegmentIndex == 1)
        {
            months = ["Jan", "Feb", "Mar","April","May","June","July","August","Sep","Oct","Nov","Dec"]
            let unitsSold = [0.0, 20.0, 5.0,100.0, 20.0, 5.0,100.0, 20.0, 5.0,100.0, 20.0, 5.0]
            
            setChart(months, values: unitsSold)
        }
        else if(segmentedTab.selectedSegmentIndex == 2)
        {
            months = ["Jan", "Feb", "Mar","April","May","June","July","August","Sep","Oct","Nov","Dec"]
            let unitsSold = [100.0, 20.0, 5.0,100.0, 20.0, 5.0,100.0, 20.0, 5.0,100.0, 20.0, 5.0]
            
            setChart(months, values: unitsSold)
        }

        
    }
    
    func setChart(dataPoints:[String], values:[Double]){
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Number of Incidents")
        let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        barChartSummary.data = chartData

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
