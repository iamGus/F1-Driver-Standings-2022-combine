//
//  RootNaviagtionController.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import UIKit

class RootNaviagtionController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let rootTableViewController = topViewController as? RootTableViewController {
            
            let f1Service = F1APIService()
            let repository = F1Repository(f1Service: f1Service)
            rootTableViewController.model = DriverStandingsViewModel(f1Repository: repository)
        }
  
    }
}
