//
//  DriverStanding.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation

struct DriverStanding: Codable {
    
    struct Driver: Codable {
        let driverId: String
        let permanentNumber: String
        let code: String
        let url: String
        let givenName: String
        let familyName: String
        let dateOfBirth: String
        let nationality: String
    }
    
    struct Constructors: Codable {
        let constructorId: String
        let url: String
        let name: String
        let nationality: String
    }
    
    let position: String
    let positionText: String
    let points: String
    let wins: String
    let driver: Driver
    let constructors: [Constructors]
    
    enum CodingKeys: String, CodingKey {
        case position
        case positionText
        case points
        case wins
        case driver = "Driver"
        case constructors = "Constructors"
    }
}

// MARK: - Helper Extensions

extension DriverStanding {
    
    var driverFullName: String {
        "\(driver.givenName) \(driver.familyName)"
    }
    
    var constructorsName: String? {
        constructors.first?.name
    }
}
