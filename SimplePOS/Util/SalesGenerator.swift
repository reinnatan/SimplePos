//
//  SalesGenerator.swift
//  SimplePOS
//
//  Created by Reinhart on 18/10/23.
//  Copyright © 2023 Reinhart Simanjuntak. All rights reserved.
//

import UIKit
import CoreData

class SalesGenerator{
    
    struct Sale {
        var day: String
        var totaPrice: Double
    }
    
    static func data(context:NSManagedObjectContext)->[Date:Int64]{
        var sales = [Sale]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "POSDataModel")
        request.returnsObjectsAsFaults = false
        var totalPrice:Int64 = 0;
        var transactionData = [Date:Int64] ()
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if transactionData[data.value(forKey: "dateTrx") as! Date] == nil{
                    let date = data.value(forKey: "dateTrx") as! Date
                    totalPrice = data.value(forKey: "total") as! Int64
                    transactionData[date] = totalPrice
                }else{
                    let date = data.value(forKey: "dateTrx") as! Date
                    totalPrice += data.value(forKey: "total") as! Int64
                    transactionData.updateValue(totalPrice, forKey: date)
                }
            
                //print("Datanya : \(data.value(forKey: "name") as! String) \(data.value(forKey: "price") as! Int64)")
            }
                   
        } catch {
            print("Failed")
        }
        
        return transactionData
        
    }

}
