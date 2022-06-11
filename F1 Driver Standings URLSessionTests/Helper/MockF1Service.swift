//
//  MockF1Service.swift
//  F1 Driver Standings URLSessionTests
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation
@testable import F1_Driver_Standings_URLSession

struct MockF1Service: F1Service {
    var session: URLSession
    
    let driverStandingsDesiredError: APIError?
    
    init(session: URLSession = URLSession(configuration: .default),
         driverStandingsDesiredError: APIError? = nil) {
        self.session = session
        self.driverStandingsDesiredError = driverStandingsDesiredError
    }
    
    func fetchCurrentDriverStandings(completion: @escaping (Result<[StandingsList], APIError>) -> ()) {
        
        if let driverStandingsDesiredError = driverStandingsDesiredError {
            completion(.failure(driverStandingsDesiredError))
        } else {
            
            let response = try! JSONDecoder().decode(StandingsListAPIResponse.self,
                                                     from: MockData.currentStandingsData)
            
            completion(.success(response.MRData.StandingsTable.StandingsLists))
        }
    }
}
