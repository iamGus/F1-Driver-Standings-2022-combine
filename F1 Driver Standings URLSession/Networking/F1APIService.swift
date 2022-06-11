//
//  F1APIService.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation
import Combine

class F1APIService: F1Service {
    var apiQueue: DispatchQueue
    
  
    let session: URLSession
    
    init(configuration: URLSessionConfiguration, queue: DispatchQueue) {
        self.session = URLSession(configuration: configuration)
        self.apiQueue = queue
    }
    
    convenience init() {
        
        let dispatchQueue = DispatchQueue(label: "ChuckNorrisAPI",
                          qos: .default,
                          attributes: .concurrent)
        self.init(configuration: .default, queue: dispatchQueue)
    }

    // Currently returns api response, I would refine here to return Driver Standing model
    func fetchCurrentDriverStandings() -> AnyPublisher<StandingsListAPIResponse, Error> {
        
        let endpoint = F1Endpoint.currentDriverStandings
        let request = endpoint.request
        
        return fetch(with: request, responseType: StandingsListAPIResponse.self)
    }
}
