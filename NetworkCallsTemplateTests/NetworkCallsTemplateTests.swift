//
//  NetworkCallsTemplateTests.swift
//  NetworkCallsTemplateTests
//
//  Created by Waldyr Schneider on 25/03/24.
//

import XCTest

@testable
import NetworkCallsTemplate

final class NetworkCallsTemplateTests: XCTestCase {
    
    var serviceMock: MovieDBServiceMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        serviceMock = MovieDBServiceMock()
    }

    override func tearDownWithError() throws {
        serviceMock = nil
        try super.tearDownWithError()
    }

    func testExample() throws {

    }
    
    func testServiceCorrectURL() throws {
        let url = serviceMock.setupFetchRequest(url: "http://wwww.google.com")
        XCTAssert((url as Any) is URLRequest)
    }
    
    func testServiceURLNil() throws {
        XCTAssertNil(serviceMock.setupFetchRequest(url: ""))
    }
    
    func testServiceWithData() throws {
        let expectation = XCTestExpectation(description: "\(#function)")
        var data: Data?
        
        serviceMock.fetchImage(posterPath: " ") { image in
            data = image
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertNotNil(data)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
