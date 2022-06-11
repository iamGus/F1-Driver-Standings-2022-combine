//
//  APIService.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation
import Combine

/// API Error cases
enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    //Readable description of error
    var errorDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}

protocol APIService {
    var session: URLSession { get }
    var apiQueue: DispatchQueue { get }
    
    func fetch<Y: Decodable>(with request: URLRequest, responseType: Y.Type) -> AnyPublisher<Y, Error>
}

extension APIService {
    
    /// Generic method to call dataTaskPublisher  and see if data can be parsed, if it can then return Model
    func fetch<Y: Decodable>(with request: URLRequest, responseType: Y.Type) -> AnyPublisher<Y, Error> {
        
        session.dataTaskPublisher(for: request)
            .receive(on: apiQueue)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.requestFailed
                }
                
                guard httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
                    throw APIError.responseUnsuccessful
                }
                
                // I would refine this to catch conversion of json with the decoder error and not just empty data
                guard data.isEmpty == false else {
                    throw APIError.jsonParsingFailure
                }
                return data
            }
            .decode(type: responseType, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
