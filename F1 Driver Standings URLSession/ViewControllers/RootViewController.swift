//
//  RootViewController.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 13/06/2022.
//

import UIKit
import SwiftUI

class RootViewController: UIViewController {
    
    // I would refine to use dependency injection and not create instance here
    let contentView = UIHostingController(rootView: ContentView(viewModel:DriverStandingsViewModel(f1Repository: F1Repository(f1Service: F1APIService()))))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(contentView)
        view.addSubview(contentView.view)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
