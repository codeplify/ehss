//
//  IncidentCategoryVC.swift
//  ehss
//
//  Created by IOS1-PC on 5/10/16.
//  Copyright (c) 2016 AgdanL. All rights reserved.
//

import UIKit
import Charts

class IncidentCategoryVC: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    
    var category:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        category = ["Safety","","Environment","","Health","","Security","","Others",""]
        
        let values = [7.00,0.00,1.00,0.00, 5.00,0.00, 2.00,0.00, 1.00,0.00]
        
        setChart(category, values: values)
        
             // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints:[String], values:[Double]){
        barChartView.noDataText = "No Data"

        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Number of Incidents")
        let chartData = BarChartData(xVals: category, dataSet: chartDataSet)
        barChartView.xAxis.labelPosition = .Bottom
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        barChartView.data = chartData
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
