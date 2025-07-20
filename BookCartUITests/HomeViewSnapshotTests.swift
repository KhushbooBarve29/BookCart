//
//  HomeViewSnapshotTests.swift
//  BookCartUITests
//
//  Created by Khushboo Barve on 20/07/2025.
//

import XCTest
import SnapshotTesting
import SwiftUI
@testable import BookCart

class HomeViewSnapshotTests: XCTestCase {
    func testBookListView() {
        let mockBooks = [
            Book(key: "1", title: "Mock Book", cover_id: 101, authors: [Author(name: "Mock Author")])
        ]
        let viewModel = BookViewModel()
        viewModel.books = mockBooks

        let view = HomeView()

        // Snapshot in light mode, iPhone 13 frame
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
}
