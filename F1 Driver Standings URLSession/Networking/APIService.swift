//
//  APIService.swift
//  F1 Driver Standings URLSession
//
//  Created by Angus Muller on 30/05/2022.
//

import Foundation

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
    
    
    func fetch<T: Decodable, Y: Decodable>(with request: URLRequest, responseType: Y.Type, decode: @escaping (Decodable) -> [T], completion: @escaping (Result<[T], APIError>) -> Void)
}

extension APIService {

    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    /// Returns instance of URLSessionDataTask with Json data
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 {
                if let data = data {
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                         completion(genericModel, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        
        return task
    }
    /// Generic method to call decodingTask and see if data can be parsed, if it can then return Model
    func fetch<T: Decodable, Y: Decodable>(with request: URLRequest, responseType: Y.Type, decode: @escaping (Decodable) -> [T], completion: @escaping (Result<[T], APIError>) -> Void) {
        let task = decodingTask(with: request, decodingType: Y.self) { json, error in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(Result.failure(error))
                    } else {
                        completion(Result.failure(.invalidData)) // If no specific error message give generic error
                    }
                    return // return from error
                }
                
                let value = decode(json) // If data is successfully parsed
                
                if !value.isEmpty {
                    completion(Result.success(value))
                } else {
                    completion(Result.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
    
}
