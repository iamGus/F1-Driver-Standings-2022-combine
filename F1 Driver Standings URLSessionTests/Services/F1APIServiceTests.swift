//
//  F1APIServiceTests.swift
//  F1 Driver Standings URLSessionTests
//
//  Created by Angus Muller on 31/05/2022.
//

import XCTest

import Mocker

@testable import F1_Driver_Standings_URLSession

class F1APIServiceTests: XCTestCase {
    
    var service: F1APIService!
    
    override func setUpWithError() throws {
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        
        service = F1APIService(configuration: configuration)
    }
    
    override func tearDownWithError() throws {
        
        service = nil
        URLSessionConfiguration.default.protocolClasses = []
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
        
        service.fetchCurrentDriverStandings { (result) in
            
            switch result {
            case .failure(_):
                XCTFail("request should have succeeded")
            case .success(_):
                succeedsExpectation.fulfill()
            }
        }
        
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
        
        service.fetchCurrentDriverStandings { (result) in

            switch result {
            case .failure(let error):
                XCTAssertEqual(.responseUnsuccessful, error)
                failsExpectation.fulfill()
            case .success(_):
                XCTFail("request should have failed")
            }
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testfetchCurentStandings_InvalidJson_FailsWithJsonConversionFailure() {
        
        let failsExpectation = expectation(description: "Fails")
        
        let endpoint = F1Endpoint.currentDriverStandings
        
        let mock = Mock(url: endpoint.request.url!,
                        dataType: .json,
                        statusCode: 200,
                        data: [.get : Data()])
        mock.register()
        
        service.fetchCurrentDriverStandings { (result) in
            
            switch result {
            case .failure(let error):
                XCTAssertEqual(.jsonConversionFailure, error)
                failsExpectation.fulfill()
            case .success(_):
                XCTFail("request should have failed")
            }
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
