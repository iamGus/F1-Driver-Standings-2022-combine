//
//  Endpoint.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation

/// A type that provides URLRequests for defined API endpoints
protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItem: [URLQueryItem] { get }
}

extension Endpoint {
    /// Returns an instance of URLComponents containing the base URL, path and
    /// query items provided
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItem
        
        return components
    }
    
    /// Returns an instance of URLRequest encapsulating the endpoint URL. This
    /// URL is obtained through the `urlComponents` object.
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

enum F1Endpoint {
    
    case currentDriverStandings
}

extension F1Endpoint: Endpoint {
    var base: String {
        return "https://ergast.com"
    }
    
    var path: String {
        switch self {
        case .currentDriverStandings: return "/api/f1/current/driverStandings.json"
        }
    }
    
    var queryItem: [URLQueryItem] {
        switch self {
        case .currentDriverStandings: return []
        }
    }
}
