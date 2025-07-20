//
//  BookService.swift
//  BookCart
//
//  Created by Khushboo Barve on 18/07/2025.
//

import Foundation

// Protocol to allow mocking or abstraction
protocol BookServiceProtocol {
    func fetchBooks(for subject: String) async throws -> [Book]
}

class BookService: BookServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchBooks(for subject: String) async throws -> [Book] {
        guard let url = buildQuery(subject: subject) else {
            throw BookAPIError.badURL
        }
        
        let (data, _) = try await session.data(from: url)
        let decoded = try JSONDecoder().decode(BookList.self, from: data)
        return decoded.works
    }
    
    private func buildQuery(subject: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = URL(string: Constants.baseURL)?.host
        components.path = "/subjects/\(subject).json"
        return components.url
    }
}


