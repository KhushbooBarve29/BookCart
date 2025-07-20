//
//  BookViewModelTests.swift
//  BookCartTests
//
//  Created by Khushboo Barve on 19/07/2025.
//

import XCTest
@testable import BookCart

final class BookViewModelTests: XCTestCase {
    var viewModel: BookViewModel!
    var mockService: BookServiceMock!

     override func setUpWithError() throws {
        mockService = BookServiceMock()
        viewModel = BookViewModel(service: mockService)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockService = nil
    }

    func testStaticStrings() {
        XCTAssertEqual(viewModel.titleHeader, "Book Detail")
        XCTAssertEqual(viewModel.alertErrorTitle, "Error")
        XCTAssertEqual(viewModel.alertErrorMessage, "Something went wrong.")
        XCTAssertEqual(viewModel.alertErrorButton, "OK")
        XCTAssertEqual(viewModel.title, "Home")
        XCTAssertEqual(viewModel.subTitle, "Sci-fi Books")
        XCTAssertEqual(viewModel.homeAlertTitle, "Notice")
    }
    
    func testLoadBooksSuccess() async {
        // Prepared mock JSON matching your BookList model
        let mockBook = Book(
            key: "OL12345M",
            title: "Mock Book",
            cover_id: 101,
            authors: [Author(name: "Mock Author")]
        )
        mockService.mockBooks = [mockBook]
        mockService.shouldThrowError = false

        let expectation = expectation(description: "Books loaded")

        await viewModel.loadBooks(for: "mock-subject")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)

        XCTAssertFalse(viewModel.isLoading, "Loading should stop after success")
        XCTAssertEqual(viewModel.books.count, 1, "Should load 1 mock book")
        XCTAssertEqual(viewModel.books.first?.title, "Mock Book")
        XCTAssertEqual(viewModel.books.first?.authorName, "Mock Author")
        XCTAssertFalse(viewModel.showAlert, "No alert expected on success")
    }

    func testLoadBooksFailureWithBadResponse() async {
        mockService.shouldThrowError = true
        mockService.errorType = .badResponse

        let expectation = expectation(description: "Error handled and alert shown")

        await viewModel.loadBooks(for: "mock-subject")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.contains("Invalid response"))
        XCTAssertEqual(viewModel.books.count, 1)
    }

    func testLoadBooksFailureWithCachedData() async {
        let cachedBook = Book(
            key: "OL54321M",
            title: "Cached Book",
            cover_id: 202,
            authors: [Author(name: "Cached Author")]
        )
        CoreDataCacheManager.shared.saveBooks([cachedBook])

        mockService.shouldThrowError = true
        mockService.errorType = .badResponse

        let expectation = expectation(description: "Fallback to cached data")

        await viewModel.loadBooks(for: "mock-subject")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)

        XCTAssertTrue(viewModel.showAlert)
        XCTAssertTrue(viewModel.alertMessage.contains("Showing cached books"))
        XCTAssertEqual(viewModel.books.count, 1)
        XCTAssertEqual(viewModel.books.first?.title, "Cached Book")
        XCTAssertEqual(viewModel.books.first?.authorName, "Cached Author")

        CoreDataCacheManager.shared.clearBooks()
    }
}
