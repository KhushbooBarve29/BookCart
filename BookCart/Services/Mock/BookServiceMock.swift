//
//  BookServiceMock.swift
//  BookCart
//
//  Created by Khushboo Barve on 18/07/2025.
//

import Foundation

enum BookAPIError: Error {
    case noError
    case badURL
    case badResponse
    case noData
    case decodingFailed
    
    func description() -> String {
        switch self {
        case .noError: return "No error"
        case .badURL: return "Invalid URL"
        case .badResponse: return "Invalid response from server"
        case .noData: return "No data received"
        case .decodingFailed: return "Failed to decode the data"
        }
    }
}

class BookServiceMock: BookServiceProtocol {
    var mockBooks: [Book] = []
    var shouldThrowError: Bool = false
    var errorType: BookAPIError = .noError
    
    func fetchBooks(for subject: String) async throws -> [Book] {
        if shouldThrowError {
            throw errorType
        }
        
        if mockBooks.isEmpty {
            throw BookAPIError.noData
        }
        
        return mockBooks
    }
}
