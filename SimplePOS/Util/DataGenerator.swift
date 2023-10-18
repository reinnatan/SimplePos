//
//  DataGenerator.swift
//  SimplePOS
//
//  Created by Reinhart on 18/10/23.
//  Copyright © 2023 Reinhart Simanjuntak. All rights reserved.
//

import UIKit

struct Sale {
    var month: String
    var value: Double
}

class DataGenerator {
    
    static var randomizedSale: Double {
            return Double(arc4random_uniform(10000) + 1) / 10
        }
        
        static func data() -> [Sale] {
            let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            var sales = [Sale]()
     
            for month in months {
                let sale = Sale(month: month, value: randomizedSale)
                sales.append(sale)
            }
            
            return sales
        }

}
