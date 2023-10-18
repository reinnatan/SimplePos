//
//  DialogChart.swift
//  SimplePOS
//
//  Created by Reinhart on 18/10/23.
//  Copyright © 2023 Reinhart Simanjuntak. All rights reserved.
//

import UIKit
import DGCharts


class DialogChart: UIViewController {
    
    @IBOutlet weak var barchartView: BarChartView!
    
    override func viewDidLoad() {
        let sales = DataGenerator.data()
        
        var salesEntries = [ChartDataEntry]()
            
            // Initialize an array to store months (labels; x axis)
            var salesMonths = [String]()
            
            var i = 0
            for sale in sales {
                // Create single chart data entry and append it to the array
           
                let saleEntry = BarChartDataEntry(x: Double(i), y: Double((i+1))*10, data:sale.value )
                salesEntries.append(saleEntry)
                
                // Append the month to the array
                salesMonths.append(sale.month)
                
                i += 1
            }
            
            // Create bar chart data set containing salesEntries
        let chartDataSet = BarChartDataSet(entries: salesEntries, label: "Profit")
            
            // Create bar chart data with data set and array with values for x axis
            let chartData = BarChartData(dataSets: [chartDataSet])
            
            // Set bar chart data to previously created data
            barchartView.data = chartData
    }
    
    
}
