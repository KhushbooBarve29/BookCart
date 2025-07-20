//
//  BookServiceTests.swift
//  BookCartTests
//
//  Created by Khushboo Barve on 18/07/2025.
//

import XCTest
@testable import BookCart

class BookServiceTests: XCTestCase {
    var service: BookService!
    var session: URLSession!

    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        
        service = BookService(session: session)
        MockURLProtocol.requestHandler = nil
    }
    
    override func tearDown() {
        service = nil
        session = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    func test_fetchBooks_success() async throws {
        // Prepared mock JSON matching your BookList model
        let jsonString = """
        {
          "works": [
            {
              "key": "OL12345M",
              "title": "Test Book Title",
              "cover_id": 123,
              "authors": [{"name": "John Doe"}]
            }
          ]
        }
        """
        let data = jsonString.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }

        let books = try await service.fetchBooks(for: "test-subject")

        XCTAssertEqual(books.count, 1)
        XCTAssertEqual(books.first?.title, "Test Book Title")
        XCTAssertEqual(books.first?.authorName, "John Doe")
        XCTAssertEqual(books.first?.cover_id, 123)
    }

    func test_fetchBooks_failure_badResponse() async throws {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        do {
            _ = try await service.fetchBooks(for: "test-subject")
            XCTFail("Expected failure but got success")
        } catch {
            XCTAssertTrue(true)
        }
    }
}
