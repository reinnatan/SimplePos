//
//  DetailitemViewCell.swift
//  SimplePOS
//
//  Created by Reinhart Simanjuntak on 10/31/20.
//  Copyright © 2020 Reinhart Simanjuntak. All rights reserved.
//

import UIKit

class DetailitemViewCell: UICollectionViewCell {

    @IBOutlet weak var foodPicture: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupItem(){
        
    }
}
