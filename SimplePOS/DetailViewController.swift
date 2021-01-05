//
//  DetailViewController.swift
//  SimplePOS
//
//  Created by Reinhart Simanjuntak on 10/30/20.
//  Copyright © 2020 Reinhart Simanjuntak. All rights reserved.
//

import UIKit

protocol DetailViewDelegate {
    func selectFood(foodSelected:FoodMenus)
}

class DetailViewController:UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var detailFoodLists: UICollectionView!
    var foodMenus = [FoodMenus]()
    var itemSelectedDelegate: DetailViewDelegate!
    
    init(itemSelected:DetailViewDelegate) {
        super.init(nibName: "DetailViewController", bundle: nil)
        self.itemSelectedDelegate = itemSelected
    }
    
    required init?(coder: NSCoder) {
        fatalError("Terjadi Error di initialize")
    }
    
    override func viewDidLoad() {
        setupData()
        detailFoodLists.register(UINib(nibName: "DetailitemViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        detailFoodLists.delegate = self
        detailFoodLists.dataSource = self
        
    }
    
    func setupData(){
        let menu1 = FoodMenus(foodId: 1, foodPicture: "burger", foodName: "Burger", foodPrice: 35000)
        let menu2 = FoodMenus(foodId: 2, foodPicture: "frenchfries", foodName: "French Fries", foodPrice: 45000)
        let menu3 =  FoodMenus(foodId: 3, foodPicture: "milkshake", foodName: "Milk Shake", foodPrice: 40000)
        let menu4 = FoodMenus(foodId: 4, foodPicture: "onionring", foodName: "Onion Ring", foodPrice: 30000)
        let menu5 = FoodMenus(foodId: 5, foodPicture: "pizza", foodName: "Pizza", foodPrice: 120000)
        foodMenus.append(menu1)
        foodMenus.append(menu2)
        foodMenus.append(menu3)
        foodMenus.append(menu4)
        foodMenus.append(menu5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodMenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DetailitemViewCell
        
        cell.foodPicture.image = UIImage(named: foodMenus[indexPath.row].foodPicture)
        cell.foodName.text = foodMenus[indexPath.row].foodName
        cell.foodPrice.text = "\(foodMenus[indexPath.row].foodPrice)"
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.itemSelectedDelegate.selectFood(foodSelected: foodMenus[indexPath.row])
    }
    
   
    
    /*
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
     return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
     }
     */
    
}



