//
//  F1APIService.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation

class F1APIService: F1Service {
  
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }

    func fetchCurrentDriverStandings(completion: @escaping (Result<[StandingsList], APIError>) -> Void) {
        
        let endpoint = F1Endpoint.currentDriverStandings
        let request = endpoint.request
        
        fetch(with: request, responseType: StandingsListAPIResponse.self, decode: { (dataResponse) -> [StandingsList] in
            
            guard let standingsListResponse = dataResponse as? StandingsListAPIResponse else {
                return []
            }
            return standingsListResponse.MRData.StandingsTable.StandingsLists
        }, completion: completion)
    }
}
