//
//  DriverStandingsViewModel.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation
import Combine

class DriverStandingsViewModel: ObservableObject {
    
    @Published private(set) var driverStanding: [DriverStanding] = []
    
    //TODO: As now using SwiftUI need to update view to use errorMessage
    @Published private(set) var errorMessage: String?
    
    private var f1Repository: F1Repository
    
    private var subscriptions = [AnyCancellable]()
    
    init(f1Repository: F1Repository) {
        self.f1Repository = f1Repository
    }
    
    /// Gets the latest set of Driver Standings
    func refresh() {
        
        f1Repository.fetchCurrentDriverStandings()
            .receive(on: DispatchQueue.main)
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
                if let driverStanding = response.MRData.StandingsTable.StandingsLists.first?.driverStandings {
                    self?.driverStanding = driverStanding
                }
            }
            .store(in: &subscriptions)
    }
}

