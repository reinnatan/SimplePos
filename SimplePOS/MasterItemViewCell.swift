//
//  MasterItemViewCell.swift
//  SimplePOS
//
//  Created by Reinhart Simanjuntak on 11/1/20.
//  Copyright © 2020 Reinhart Simanjuntak. All rights reserved.
//

import UIKit
protocol MasterItemviewCellDelegate{
    func decreaseItem(id:Int)
    func increaseItem(id:Int)
}

class MasterItemViewCell: UICollectionViewCell {

    @IBOutlet weak var foodImageSelected: UIImageView!
    @IBOutlet weak var foodNameSelected: UILabel!
    @IBOutlet weak var foodCountSelected: UITextField!
    @IBOutlet weak var foodPriceTotal: UILabel!
    var delegate:MasterItemviewCellDelegate!
    var id:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func decreaseItemButton(_ sender: Any) {
        delegate.decreaseItem(id: id)
    }
    
    @IBAction func increaseItemButton(_ sender: Any) {
        delegate.increaseItem(id: id)
    }
}
