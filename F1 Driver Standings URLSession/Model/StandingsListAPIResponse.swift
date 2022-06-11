//
//  StandingsListAPIResponse.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation

struct StandingsListAPIResponse: Codable {
    
    struct StandingsTable: Codable {
        let StandingsTable: StandingList
    }
    
    struct StandingList: Codable {
        let season: String
        let StandingsLists: [StandingsList]
    }
    
    let MRData: StandingsTable
}
