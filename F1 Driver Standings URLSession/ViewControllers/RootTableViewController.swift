//
//  RootTableViewController.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import UIKit
import Combine

class RootTableViewController: UITableViewController {
    
    var model: DriverStandingsViewModel?
    private var subscriptions = [AnyCancellable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Loading Standings".localised()

        setupRefreshControl()
        refreshContent()
        
        model?.$standing.receive(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (standing) in
                
                self?.refreshControl?.endRefreshing()
                self?.title = self?.model?.seasonName()?.localised()
                self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
        
        model?.$errorMessage.receive(on: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (errorMessage) in
                
                guard let errorMessage = errorMessage else { return }
                self?.displayErrorToUser(message: errorMessage)
            })
            .store(in: &subscriptions)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.driverStandingCount() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandingCell", for: indexPath)
        
        if let driverStanding = model?.driverStanding(at: indexPath.row) {
            cell.textLabel?.text = driverStanding.driverFullName
            cell.detailTextLabel?.text = driverStanding.constructorsName
        }
        
        return cell
    }
    
    // MARK: Actions
    
    @objc func refresh(_ sender: AnyObject) {
       refreshContent()
    }

    // MARK: Helpers
    
    private func refreshContent() {
        
        guard let model = model else {
            fatalError("There is no model for RootTableViewController") // We would fail more elegantly in prod code
        }
        
        model.refresh()
    }
    
    private func displayErrorToUser(message: String) {
        
        let alert = UIAlertController(title: "Error Loading Standings".localised(),
                          message: message.localised(),
                          preferredStyle: .alert)
        
        alert.addAction(.init(title: "Ok".localised(),
                              style: .default,
                              handler: nil))
        alert.addAction(.init(title: "Try Again", style: .default) { [weak self] _ in
            self?.refreshContent()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setupRefreshControl() {
        
        refreshControl = .init()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
    }

}

