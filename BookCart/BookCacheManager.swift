////
////  BookCacheManager.swift
////  BookCart
////
////  Created by Khushboo Barve on 18/07/2025.
////
//
//import Foundation
//import UIKit
//import CoreData
//
//class BookCacheManager {
//    static let shared = BookCacheManager()
//    private init() {}
//
//    private let bookListCacheFile = "cached_books.json"
//
//    // MARK: - Book List Caching (JSON)
//    func saveBooks(_ books: [Book]) {
//        let encoder = JSONEncoder()
//        if let data = try? encoder.encode(books) {
//            let url = getDocumentsDirectory().appendingPathComponent(bookListCacheFile)
//            try? data.write(to: url)
//        }
//    }
//
//    func loadBooks() -> [Book]? {
//        let url = getDocumentsDirectory().appendingPathComponent(bookListCacheFile)
//        guard let data = try? Data(contentsOf: url) else { return nil }
//        let decoder = JSONDecoder()
//        return try? decoder.decode([Book].self, from: data)
//    }
//
//    // MARK: - Image Caching
//    func saveImage(_ image: UIImage, for key: String) {
//        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
//        let url = getImagePath(for: key)
//        try? data.write(to: url)
//    }
//
//    func loadImage(for key: String) -> UIImage? {
//        let url = getImagePath(for: key)
//        guard FileManager.default.fileExists(atPath: url.path),
//              let data = try? Data(contentsOf: url),
//              let image = UIImage(data: data) else {
//            return nil
//        }
//        return image
//    }
//
//    func imageExists(for key: String) -> Bool {
//        return FileManager.default.fileExists(atPath: getImagePath(for: key).path)
//    }
//
//    // MARK: - Helpers
//    private func getImagePath(for key: String) -> URL {
//        return getDocumentsDirectory().appendingPathComponent("\(key).jpg")
//    }
//
//    private func getDocumentsDirectory() -> URL {
//        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    }
//}
