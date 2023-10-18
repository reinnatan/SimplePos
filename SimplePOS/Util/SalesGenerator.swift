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
    
    static func data(context:NSManagedObjectContext)->[Sale]{
        var sales = [Sale]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "POSDataModel")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                    print("Datanya : \(data.value(forKey: "name") as! String) \(data.value(forKey: "price") as! Int64)")
            }
                   
        } catch {
            print("Failed")
        }
        
        return sales
        
    }

}
