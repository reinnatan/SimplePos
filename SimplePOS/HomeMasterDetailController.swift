//
//  ViewController.swift
//  SimplePOS
//
//  Created by Reinhart Simanjuntak on 10/30/20.
//  Copyright © 2020 Reinhart Simanjuntak. All rights reserved.
//

import UIKit

class HomeMasterDetailController:UISplitViewController, UISplitViewControllerDelegate{
    //
    override func viewDidLoad() {
        self.delegate = self
        
        let masterVC = MasterViewController()
        let detailVC = DetailViewController(itemSelected: masterVC)
        let masterNav = UINavigationController()
        let detailNav = UINavigationController()
        masterNav.viewControllers = [masterVC]
        detailNav.viewControllers = [detailVC]
        self.viewControllers = [masterNav, detailNav]
    }
    
    /*
     func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
     
     return true
     }
     */
    
}

