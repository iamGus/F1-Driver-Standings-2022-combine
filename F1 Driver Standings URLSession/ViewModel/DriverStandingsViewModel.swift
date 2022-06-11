//
//  DriverStandingsViewModel.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation

class DriverStandingsViewModel {
    
    private var standing: StandingsList?
    private var driverStanding: [DriverStanding]? {
        standing?.driverStandings
    }
    private var f1Repository: F1Repository
    
    init(f1Repository: F1Repository) {
        self.f1Repository = f1Repository
    }
    
    /// Gets the latest set of Driver Standings
    func refresh(completion: @escaping (_ errorMessage: String?) -> ()) {
        
        f1Repository.fetchCurrentDriverStandings { result in
            switch result {
            case .failure(let error):
                completion(error.errorDescription)
                
            case .success(let standing):
                self.standing = standing
                completion(nil)
            }
        }
    }
}

// MARK: - Standing data

extension DriverStandingsViewModel {
    func allDriverStandings() -> [DriverStanding]? {
        return driverStanding
    }
    
    func driverStanding(at index: Int) -> DriverStanding? {
        
        guard index < driverStandingCount() else {
            return nil
        }
        return allDriverStandings()?[index]
    }
    
    func driverStandingCount() -> Int {
        return driverStanding?.count ?? 0
    }
    
    func seasonName() -> String? {
        return standing?.season
    }
}
