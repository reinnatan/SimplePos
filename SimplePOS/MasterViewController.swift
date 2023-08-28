//
//  MasterViewController.swift
//  SimplePOS
//
//  Created by Reinhart Simanjuntak on 10/30/20.
//  Copyright © 2020 Reinhart Simanjuntak. All rights reserved.
//

import UIKit

protocol MasterViewDelegate {
    func selectMasterItem(item:String)
}

class MasterViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var foodListSelected: UICollectionView!
    @IBOutlet weak var totalPrices: UILabel!
    @IBOutlet weak var moneyChanges: UILabel!
    
    var allTotalPrice:Double = 0
    
    var menuSelected = [FoodMenuSelected]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //foodListSelected.register(MasterItemViewCell.self, forCellWithReuseIdentifier: "cell")
        foodListSelected.register(UINib(nibName: "MasterItemViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        //foodListSelected.register(MasterFooterItemViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        //let uinib = UINib(nibName: "MasterFooterItemViewCell", bundle: nil)
        foodListSelected.register(UINib(nibName: "MasterFooterItemViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        foodListSelected.delegate = self
        foodListSelected.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuSelected.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MasterItemViewCell
        cell.foodImageSelected.image = UIImage(named: menuSelected[indexPath.row].foodPicture)
        cell.foodNameSelected.text = menuSelected[indexPath.row].foodName
        cell.foodCountSelected.text = "\(menuSelected[indexPath.row].foodAmount)"
        cell.foodPriceTotal.text = "\(menuSelected[indexPath.row].foodPriceTotal)"
        cell.delegate = self
        cell.id = menuSelected[indexPath.row].foodId
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 300, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! MasterFooterItemViewCell
            return  footer
        default:
            return UICollectionReusableView()
        }
    }
    
    @IBAction func payAllFoods(_ sender: Any) {
        let alertController = UIAlertController(title: "Total Harga \(allTotalPrice)", message: "", preferredStyle: UIAlertController.Style.alert)
        
        //let inputNumber = UITextField()
        //inputNumber.keyboardType = .numberPad
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Bayar ?"
            textField.keyboardType = .numberPad
        }
        
        let saveAction = UIAlertAction(title: "Bayar", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            
            if let moneyPay = firstTextField.text {
                if Int(moneyPay) ?? 0 >= Int(self.allTotalPrice){
                    let resultMoney =  Double(moneyPay)! - Double(self.allTotalPrice)
                    self.moneyChanges.text = "\(resultMoney)"
                }else{
                    alertController.dismiss(animated: true, completion: {
                        let alertNotEnough = UIAlertController(title: "Maaf Uang anda tidak mencukupi", message: "", preferredStyle: UIAlertController.Style.alert)
                        
                        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { alert -> Void in
                            alertNotEnough.dismiss(animated: true, completion: nil)
                        })
                        
                        
                        alertNotEnough.addAction(okButton)
                        self.present(alertNotEnough, animated: true)
                    })
                }
                
            }
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
      
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
        
    }

}


extension MasterViewController:MasterItemviewCellDelegate{
    func decreaseItem(id:Int) {
        var isExist:Bool = false
        var index:Int = 0
        for selected in menuSelected{
            if(id == selected.foodId)  {
                isExist = true
                break
            }
            index = index+1
        }
        
        allTotalPrice -= 1 *  menuSelected[index].foodPrice
        if(isExist && menuSelected[index].foodAmount>1){
            menuSelected[index].foodAmount =  menuSelected[index].foodAmount - 1
            menuSelected[index].foodPriceTotal = Double( menuSelected[index].foodAmount) *  menuSelected[index].foodPrice
        }else{
            menuSelected.remove(at: index)
        }
        
        setupTotalPrice()
        self.foodListSelected.reloadData()
    }
    
    func increaseItem(id:Int) {
        var isExist:Bool = false
        var index:Int = 0
        for selected in menuSelected{
            if(id == selected.foodId)  {
                isExist = true
                break
            }
            index = index+1
        }
        
        allTotalPrice += 1 *  menuSelected[index].foodPrice
        if(isExist){
            menuSelected[index].foodAmount =  menuSelected[index].foodAmount + 1
            menuSelected[index].foodPriceTotal = Double(menuSelected[index].foodAmount) *  menuSelected[index].foodPrice
            setupTotalPrice()
        }
        
        self.foodListSelected.reloadData()
    }
    
    func setupTotalPrice(){
        totalPrices.text = "\(allTotalPrice)"
    }
    
}

extension MasterViewController:DetailViewDelegate {
    
    func selectFood(foodSelected: FoodMenus) {
        var isExist:Bool = false
        var index:Int = 0
        for selected in menuSelected{
            if(foodSelected.foodId == selected.foodId)  {
                isExist = true
                break
            }
            index = index+1
        }
        
        if(!isExist){
            menuSelected.append(FoodMenuSelected(foodId: foodSelected.foodId, foodPicture: foodSelected.foodPicture, foodName: foodSelected.foodName, foodPrice: foodSelected.foodPrice, foodPriceTotal: foodSelected.foodPrice * 1, foodAmount: 1))
        }else{
            menuSelected[index].foodAmount =  menuSelected[index].foodAmount + 1
            menuSelected[index].foodPriceTotal = Double( menuSelected[index].foodAmount) *  menuSelected[index].foodPrice
        }
        
        allTotalPrice +=  1 * menuSelected[index].foodPrice
        setupTotalPrice()
        self.foodListSelected.reloadData()
    }
    
}
