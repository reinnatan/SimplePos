//
//  DialogChart.swift
//  SimplePOS
//
//  Created by Reinhart on 18/10/23.
//  Copyright © 2023 Reinhart Simanjuntak. All rights reserved.
//

import UIKit
import DGCharts
import CoreData


class DialogChart: UIViewController {
    
    @IBOutlet weak var barchartView: BarChartView!
    
    override func viewDidLoad() {
        var transactionData:[Date:Int64] = [Date:Int64]()
        
        let container = NSPersistentContainer(name: "POSDataModel")
            container.loadPersistentStores(completionHandler: {
                        (description, error) in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                } else {
                    transactionData =  SalesGenerator.data(context: container.viewContext)
                }
            })
        
    
    
        //var sales = [Sale]()
        var salesEntries = [ChartDataEntry]()
            
            // Initialize an array to store months (labels; x axis)
            var salesMonths = [Date]()
            
            var i = 0
            for (key, value) in transactionData  {
                // Create single chart data entry and append it to the array
           
                let saleEntry = BarChartDataEntry(x: Double(i), y: Double((i+1))*10, data:value )
                salesEntries.append(saleEntry)
                
                // Append the month to the array
                salesMonths.append(key)
                
                i += 1
            }
            
            // Create bar chart data set containing salesEntries
        let chartDataSet = BarChartDataSet(entries: salesEntries, label: "Transaction Data")
            
            // Create bar chart data with data set and array with values for x axis
            let chartData = BarChartData(dataSets: [chartDataSet])
            
            // Set bar chart data to previously created data
            barchartView.data = chartData
    }
    
    
}
