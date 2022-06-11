//
//  DriverStandingsViewModelTests.swift
//  F1 Driver Standings URLSessionTests
//
//  Created by Angus Muller on 31/05/2022.
//

import XCTest

@testable import F1_Driver_Standings_URLSession

class DriverStandingsViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
             // Put setup code here. This method is called before the invocation of each test method in the class.
         }

     override func tearDownWithError() throws {
         // Put teardown code here. This method is called after the invocation of each test method in the class.
     }
    
    func testInitViewModel_ReturnsObject() {
        
        let exp = expectation(description: "Success")
        
        let mockService = MockF1Service()
        let repository = F1Repository(f1Service: mockService)
        let viewModel = DriverStandingsViewModel(f1Repository: repository)
        
        viewModel.refresh { (error) in
            
            if error != nil {
                XCTFail("Test was expected to succeed")
            }
            
            XCTAssertEqual(viewModel.allDriverStandings()?.count, 21)
            XCTAssertEqual(viewModel.seasonName(), "2022")
            XCTAssertEqual(viewModel.driverStanding(at: 0)?.position, "1")
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
    
    func testInitViewModel_RequestFailedOnRefresh_ReturnsEmptyObject() {
        
        let exp = expectation(description: "Error")
        
        let mockService = MockF1Service(driverStandingsDesiredError: .requestFailed)
        let repository = F1Repository(f1Service: mockService)
        let viewModel = DriverStandingsViewModel(f1Repository: repository)
        
        viewModel.refresh { (errorMessage) in
            
            guard let errorMessage = errorMessage else {
                XCTFail("Test was expected to Fail")
                return
            }
            
            XCTAssertEqual(errorMessage, "Please check your internet connection")
            XCTAssertEqual(viewModel.allDriverStandings()?.count, nil)
            XCTAssertEqual(viewModel.seasonName(), nil)
            XCTAssertEqual(viewModel.driverStanding(at: 0)?.position, nil)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.3, handler: nil)
    }
}
