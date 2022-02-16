//
//  AlamofireTeamsRepository.swift
//  P12_nakache_jeremyTests
//
//  Created by user on 11/02/2022.
//
import XCTest
@testable import P12_nakache_jeremy
@testable import Alamofire

class AlamofireTeamsTest: XCTestCase {
    
    private var sut: TeamsRepository!
    
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
        sut = TeamsRepository(manager: manager)
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
    }
    
    func test_status_code200_returns_status_code200() throws {
        
        
        let expectation = XCTestExpectation(description: "Performs a request")
        
        let expectedResultCount = 1
        let expectedResult = TeamsStructJson(get: "", parameters: ParametersTeam(id: ""), errors: [""], results: expectedResultCount, paging: PagingTeam(current: 1, total: 1), response: [])
        
        let expectedResultData = try! JSONEncoder().encode(expectedResult)
        
        MockURLProtocol.responseWithStatusCode(code: 200, data: expectedResultData)
        
        sut.getDataTeams(endPoint: "teams") { (result) in
            let teams = try! result.get()
            XCTAssertEqual(teams.results, expectedResultCount)
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
        
        sut.getDataTeams(endPoint: "teams") { (result) in
            let standing = result.isFailure
            XCTAssertEqual(standing, true)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_response_with_failure_returns_failure() throws {
        // given
        
        let expectation = XCTestExpectation(description: "Performs a request")
        MockURLProtocol.responseWithFailure()
        // when
        sut.getDataTeams(endPoint: "teams") { (result) in
            let failure = result.failure
            XCTAssertNotNil(failure)
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 3)
        
    }
}
