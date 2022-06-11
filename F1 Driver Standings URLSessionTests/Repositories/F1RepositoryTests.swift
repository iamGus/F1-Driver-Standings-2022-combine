//
//  F1RepositoryTests.swift
//  F1 Driver Standings URLSessionTests
//
//  Created by Angus Muller on 30/05/2022.
//

import XCTest

@testable import F1_Driver_Standings_URLSession

class F1RepositoryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // MARK: Name Tests
    
    func testfetchCurrentStandings_WebRequestValid_ReturnsCurrentStandings() {
        
        let exp = expectation(description: "Success")
    
        let webService = MockF1Service(driverStandingsDesiredError: nil)
        let respository = F1Repository(f1Service: webService)
        
        respository.fetchCurrentDriverStandings { (result) in
            switch result {
            case .failure(_):
                XCTFail("Test was expected to succeed")
                
            case .success(let model):
                XCTAssertEqual(model.season, "2022")
                exp.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testfetchCurrentStandings_WebRequestInvalidData_ReturnsError() {
        
        let exp = expectation(description: "Error")
    
        let webService = MockF1Service(driverStandingsDesiredError: .invalidData)
        let respository = F1Repository(f1Service: webService)
        
        respository.fetchCurrentDriverStandings { (result) in
            switch result {
            case .failure(let error):
                switch error {
                case .noContent:
                    exp.fulfill()
                default:
                    XCTFail("Failed with incorrect error")
                }
                
            case .success(_):
                XCTFail("Test was expected to fail")
            }
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testfetchCurrentStandings_WebRequestRequestFailed_ReturnsError() {
        
        let exp = expectation(description: "Error")
    
        let webService = MockF1Service(driverStandingsDesiredError: .requestFailed)
        let respository = F1Repository(f1Service: webService)
        
        respository.fetchCurrentDriverStandings { (result) in
            switch result {
            case .failure(let error):
                switch error {
                case .connectionIssue:
                    exp.fulfill()
                default:
                    XCTFail("Failed with incorrect error")
                }
                
            case .success(_):
                XCTFail("Test was expected to fail")
            }
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
}
