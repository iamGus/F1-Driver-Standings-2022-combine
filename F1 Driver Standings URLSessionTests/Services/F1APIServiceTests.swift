//
//  F1APIServiceTests.swift
//  F1 Driver Standings URLSessionTests
//
//  Created by Angus Muller on 31/05/2022.
//

import XCTest

import Mocker
import Combine

@testable import F1_Driver_Standings_URLSession

class F1APIServiceTests: XCTestCase {
    
    var service: F1APIService!
    
    var subscriptions: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        
        let dispatchQueue = DispatchQueue(label: "ChuckNorrisAPI",
                          qos: .default,
                          attributes: .concurrent)
        
        service = F1APIService(configuration: configuration, queue: dispatchQueue)
    }
    
    override func tearDownWithError() throws {
        
        service = nil
        URLSessionConfiguration.default.protocolClasses = []
        subscriptions = []
    }
    
    // MARK: Login Tests
    
    func testfetchCurentStandings_Status200_Succeeds() {
        
        let succeedsExpectation = expectation(description: "Success")
        
        let endpoint = F1Endpoint.currentDriverStandings
        
        let mock = Mock(url: endpoint.request.url!,
                        dataType: .json,
                        statusCode: 200,
                        data: [.get : MockData.currentStandingsData])
        mock.register()
        
        let service = self.service.fetchCurrentDriverStandings()
        
        service.sink { (completion) in
            
        } receiveValue: { (result) in
            succeedsExpectation.fulfill()
        }
        .store(in: &subscriptions)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testfetchCurentStandings_Status500_FailsWithServerError() {
        
        let failsExpectation = expectation(description: "fails")
        
        let endpoint = F1Endpoint.currentDriverStandings
        
        let mock = Mock(url: endpoint.request.url!,
                        dataType: .json,
                        statusCode: 500,
                        data: [.get : Data()],
                        requestError: URLError.networkConnectionLost as? Error)
        mock.register()
        
        let service = self.service.fetchCurrentDriverStandings()

        service.sink { (completion) in
            switch completion {
            case .failure(let error):
                if let error = error as? APIError {
                    XCTAssertEqual(APIError.responseUnsuccessful, error)
                    failsExpectation.fulfill()
                } else {
                    XCTFail("request should have failed with another error")
                }
            case .finished:
                XCTFail("request should have failed with another error")
            }
            
        } receiveValue: { (result) in
            XCTFail("request should have failed")
        }
        .store(in: &subscriptions)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testfetchCurentStandings_InvalidJson_FailedjsonParsingFailure() {
        
        let failsExpectation = expectation(description: "Fails")
        
        let endpoint = F1Endpoint.currentDriverStandings
        
        let mock = Mock(url: endpoint.request.url!,
                        dataType: .json,
                        statusCode: 200,
                        data: [.get : Data()])
        mock.register()
        
        let service = self.service.fetchCurrentDriverStandings()

        service.sink { (completion) in
            switch completion {
            case .failure(let error):
                if let error = error as? APIError {
                    XCTAssertEqual(.jsonParsingFailure, error)
                    failsExpectation.fulfill()
                } else {
                    XCTFail("request should have failed with another error")
                }
            case .finished:
                XCTFail("request should have failed with another error")
            }
            
        } receiveValue: { (result) in
            XCTFail("request should have failed")
        }
        .store(in: &subscriptions)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
 
}
