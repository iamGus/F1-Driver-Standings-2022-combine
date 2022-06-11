//
//  StangingsList.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation

struct StandingsList: Codable {
    
    let season: String
    let round: String
    let driverStandings: [DriverStanding]
    
    enum CodingKeys: String, CodingKey {
        case season
        case round
        case driverStandings = "DriverStandings"
    }
}
