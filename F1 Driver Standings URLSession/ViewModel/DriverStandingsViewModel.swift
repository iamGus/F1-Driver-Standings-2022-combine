//
//  DriverStandingsViewModel.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation
import Combine

class DriverStandingsViewModel {
    
    @Published private(set) var standing: StandingsList?
    
    @Published private(set) var errorMessage: String?
    
    private var driverStanding: [DriverStanding]? {
        standing?.driverStandings
    }
    
    private var f1Repository: F1Repository
    
    private var subscriptions = [AnyCancellable]()
    
    init(f1Repository: F1Repository) {
        self.f1Repository = f1Repository
    }
    
    /// Gets the latest set of Driver Standings
    func refresh() {
        
        f1Repository.fetchCurrentDriverStandings()
            .sink { [weak self] (completion) in
                switch completion {
                case .failure(let error):
                    if let error = error as? APIError {
                        // I would refine to have the repository return error in F1RepositoryError type
                        let repositoryError = F1RepositoryError(error)
                        self?.errorMessage = repositoryError.errorDescription
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] (response) in
                self?.standing = response.MRData.StandingsTable.StandingsLists.first
            }
            .store(in: &subscriptions)
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
