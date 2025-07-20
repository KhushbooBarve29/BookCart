//
//  Book.swift
//  BookCart
//
//  Created by Khushboo Barve on 17/07/2025.
//

import Foundation

struct BookList: Codable {
    let works: [Book]
}

struct Book: Codable, Identifiable {
    var id: String { key }
    let key: String
    let title: String
    let cover_id: Int?
    let authors: [Author]
    
    var authorName: String {
        authors.first?.name ?? "Unknown"
    }
    
    var coverImageURL: URL? {
        guard let coverId = cover_id else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-L.jpg")
    }
}

struct Author: Codable {
    let name: String
}
