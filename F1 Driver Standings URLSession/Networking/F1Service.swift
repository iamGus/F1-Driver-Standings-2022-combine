//
//  F1Service.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation
import Combine

protocol F1Service: APIService {
    func fetchCurrentDriverStandings() -> AnyPublisher<StandingsListAPIResponse, Error>
}
