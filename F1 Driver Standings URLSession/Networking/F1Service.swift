//
//  F1Service.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation

protocol F1Service: APIService {
    func fetchCurrentDriverStandings(completion: @escaping (Result<[StandingsList], APIError>) -> ())
}
