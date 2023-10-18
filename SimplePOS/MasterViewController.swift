//
//  MasterViewController.swift
//  SimplePOS
//
//  Created by Reinhart Simanjuntak on 10/30/20.
//  Copyright © 2020 Reinhart Simanjuntak. All rights reserved.
//

import UIKit
import CoreData

protocol MasterViewDelegate {
    func selectMasterItem(item:String)
}

class MasterViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var foodListSelected: UICollectionView!
    @IBOutlet weak var totalPrices: UILabel!
    @IBOutlet weak var moneyChanges: UILabel!
    @IBOutlet weak var labelDiscount: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    
    var allTotalPrice:Double = 0
    var discountParse:Double = 0
    var taxParse:Double = 0
    var managedObjectContext:NSManagedObjectContext?

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
                if Double(moneyPay) ?? 0 >= (Double(self.allTotalPrice)) - self.discountParse{
                    let resultMoney =  Double(moneyPay)! - (Double(self.allTotalPrice) - self.discountParse)
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
    
    @IBAction func setupDiscount(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Discount", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Discount"
            textField.keyboardType = .numberPad
        }
        
        let setDiscountAction = UIAlertAction(title: "Discount", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if let discountAmount = firstTextField.text {
                self.labelDiscount.text = String(Double(discountAmount) ?? 0)
                self.discountParse = Double(discountAmount) ?? 0
            }
        })
        
        let cancelDiscountAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
      
        alertController.addAction(setDiscountAction)
        alertController.addAction(cancelDiscountAction)
        self.present(alertController, animated: true)
        
        
    }
    
    @IBAction func setTax(_ sender: Any) {
        let alertController = UIAlertController(title: "Tax", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Tax"
            textField.keyboardType = .numberPad
        }
        
        let setDiscountAction = UIAlertAction(title: "Discount", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if let taxAmount = firstTextField.text {
                self.taxLabel.text = String(Double(taxAmount) ?? 0)
                self.taxParse = Double(taxAmount) ?? 0
            }
        })
        
        let cancelDiscountAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
      
        alertController.addAction(setDiscountAction)
        alertController.addAction(cancelDiscountAction)
        self.present(alertController, animated: true)
    }

    
    @IBAction func saveTransaction(_ sender: Any) {
       
      
        /*
        let container = NSPersistentContainer(name: "POSDataModel")
            container.loadPersistentStores(completionHandler: {
                        (description, error) in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                } else {
                    self.managedObjectContext = container.viewContext
                }
            })
        
        let posEntity = NSEntityDescription.entity(forEntityName: "POSDataModel", in: self.managedObjectContext!) ?? container.viewContext
                                                   
        let POSDataModel = NSManagedObject(entity: posEntity as! NSEntityDescription, insertInto: self.managedObjectContext)
        
        for menuPay in menuSelected{
            POSDataModel.setValue(menuPay.foodName, forKey: "name")
            POSDataModel.setValue(menuPay.foodPrice, forKey: "price")
            POSDataModel.setValue(menuPay.foodAmount, forKey: "price")
            POSDataModel.setValue(menuPay.foodPrice * menuPay.foodPriceTotal, forKey: "total")
            
            do {
                try managedObjectContext?.save()
                print("Data saved successfully.")
            } catch {
                print("Error saving data: \(error)")
            }
        }
         */
        let vc = DialogChart(nibName: "DialogChart", bundle: nil)
            vc.modalPresentationStyle = .pageSheet
            vc.preferredContentSize = .init(width: 800, height: 800)
            present(vc, animated: true)
        
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
