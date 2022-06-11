//
//  F1Repository.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation

enum F1RepositoryError: Error {
    case noContent
    case connectionIssue
    
    init(_ error: APIError) {
        switch error {
        case .invalidData, .jsonConversionFailure, .jsonParsingFailure:
            self = .noContent
        case .requestFailed, .responseUnsuccessful:
            self = .connectionIssue
        }
    }
    
    // Readable description of error for user
    var errorDescription: String {
        switch self {
        case .noContent: return "Sorry no data could be retrieved"
        case .connectionIssue: return "Please check your internet connection"
        }
    }
}

class F1Repository {
    private var f1Service: F1Service
    
    init(f1Service: F1Service) {
        self.f1Service = f1Service
    }
    
    /// Gets the latest set of Driver Standings
    func fetchCurrentDriverStandings(completion: @escaping (Result<StandingsList, F1RepositoryError>) -> ()) {
        f1Service.fetchCurrentDriverStandings { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(.init(error)))
            case .success(let standingList):
                guard let standingList = standingList.first else {
                    completion(.failure(.noContent))
                    return
                }
                completion(.success(standingList))
            }
        }
    }
}
