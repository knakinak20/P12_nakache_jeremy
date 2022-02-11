//
//  AlamofireResultMatchTest.swift
//  P12_nakache_jeremyTests
//
//  Created by user on 11/02/2022.
//

import XCTest
@testable import P12_nakache_jeremy
@testable import Alamofire

class AlamofireResultMatchTest: XCTestCase {
    
    private var sut: ResultRepository!
    
    override func setUp() {
        super.setUp()
        
        let manager: Session = {
            let configuration: URLSessionConfiguration = {
                let configuration = URLSessionConfiguration.default
                configuration.protocolClasses = [MockURLProtocol.self]
                return configuration
            }()
            
            return Session(configuration: configuration)
        }()
        sut = ResultRepository(manager: manager)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
    }
    
    func test_status_code200_returns_status_code200() throws {
 
        
        let expectation = XCTestExpectation(description: "Performs a request")
        
        let expectedResultCount = 1
        let expectedResult = FixtureResponse(get: "", parameters: FixtureParameters(date: "", timezone: ""), errors: [""], results: expectedResultCount, paging: FixturePaging(current: 1, total: 1), response: [])
        //Standing(rank: 1, team: TeamStanding(id: 1, name: "marseille", logo: ""), points: 32, goalsDiff: 4, group: "", form: "", status: "", description: "", all: All(played: 1, win: 1, draw: 1, lose: 1, goals: Goals(_for: 1, against: 1)), home:All(played: 1, win: 1, draw: 1, lose: 1, goals: Goals(_for: 1, against: 1)) , away: All(played: 1, win: 1, draw: 1, lose: 1, goals: Goals(_for: 1, against: 1)), update: "")
        let expectedResultData = try! JSONEncoder().encode(expectedResult)
        
        MockURLProtocol.responseWithStatusCode(code: 200, data: expectedResultData)
        
        sut.getResults(endPoint: "teams") { (result) in
            let resultMatch = try! result.get()
            XCTAssertEqual(resultMatch.results, expectedResultCount)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    func test_status_code400_returns_status_code400() throws {
  
        let expectation = XCTestExpectation(description: "Performs a request")
        
        let expectedResultCount = 1
        let expectedResult = StandingsStructJson(get: "", parameters: Parameters(league: "", season:""), errors: [""], results: expectedResultCount, paging: Paging(current: 1, total: 1), response: [])
        let expectedResultData = try! JSONEncoder().encode(expectedResult)
        
        MockURLProtocol.responseWithStatusCode(code: 400, data: expectedResultData)

        sut.getResults(endPoint: "teams") { (result) in
            let resultMatch = result.isFailure
            XCTAssertEqual(resultMatch, true)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_response_with_failure_returns_failure() throws {
        // given
        
        let expectation = XCTestExpectation(description: "Performs a request")
        MockURLProtocol.responseWithFailure()
        // when
        sut.getResults(endPoint: "teams") { (result) in
            let failure = result.failure
            XCTAssertNotNil(failure)
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 3)
        
    }
}

