//
//  CoreDataCacheManager.swift
//  BookCart
//
//  Created by Khushboo Barve on 18/07/2025.
//

import Foundation
import UIKit
import CoreData

class CoreDataCacheManager {
    static let shared = CoreDataCacheManager()
    static let FavsKey = "FavsKey"
    private init() {}
    
    // MARK: - Core Data Context
    private var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }
    
    // MARK: - Book Caching (Core Data)
    
    func saveBooks(_ books: [Book]) {
        clearBooks()
        
        for book in books {
            let entity = CDBook(context: context)
            entity.key = book.key
            entity.title = book.title
            if let coverID = book.cover_id {
                entity.coverID = Int32(coverID)
            }
            entity.authorName = book.authorName
        }
        
        do {
            try context.save()
        } catch {
            Logger.shared.log("Failed to save books to Core Data: \(error)")
        }
    }
    
    func loadBooks() -> [Book]? {
        let request: NSFetchRequest<CDBook> = CDBook.fetchRequest()
        
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                Book(
                    key: entity.key ?? UUID().uuidString,
                    title: entity.title ?? "Untitled",
                    cover_id: entity.coverID as? Int,
                    authors: [Author(name: entity.authorName ?? "Unknown")]
                )
            }
        } catch {
            Logger.shared.log("Failed to save books to Core Data: \(error)")
            return nil
        }
    }
    
    func clearBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDBook.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            Logger.shared.log("Failed to clear books from Core Data: \(error)")
        }
    }
    
    func deleteAllBooks() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDBook.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            Logger.shared.log("Failed to delete cached books: \(error)")
        }
    }
    
    // MARK: - Image Caching (still using disk)
    func saveImage(_ image: UIImage, for key: String) {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let url = getImagePath(for: key)
        try? data.write(to: url)
    }
    
    func loadImage(for key: String) -> UIImage? {
        let url = getImagePath(for: key)
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    func imageExists(for key: String) -> Bool {
        return FileManager.default.fileExists(atPath: getImagePath(for: key).path)
    }
    
    // MARK: - Helpers
    private func getImagePath(for key: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent("\(key).jpg")
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func loadALLFavs() ->[Book]{
        if let data = UserDefaults.standard.data(forKey: CoreDataCacheManager.FavsKey){
            return (try? JSONDecoder().decode([Book].self, from: data))  ?? []
        }
        return []
    }
    
    
}
