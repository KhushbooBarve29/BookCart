//
//  BookViewModel.swift
//  BookCart
//
//  Created by Khushboo Barve on 17/07/2025.
//

import Foundation
import SwiftUI

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let service: BookServiceProtocol
    
    /// Detail View
    let titleHeader: String = "ui.detail.view.title.header".localized
    let alertErrorTitle: String = "ui.detail.view.error.alert.title".localized
    let alertErrorMessage: String = "ui.detail.view.error.alert.message".localized
    let alertErrorButton: String = "ui.detail.view.error.alert.button".localized
    
    /// Home View
    let title: String = "ui.home.view.title".localized
    let subTitle: String = "ui.home.view.sub.title".localized
    let homeAlertTitle: String = "ui.home.view.error.alert.title".localized
    
    init(service: BookServiceProtocol = BookService()) {
        self.service = service
    }
    
    func loadBooks(for subject: String = Constants.defaultSubject) async {
        await MainActor.run {
            isLoading = true
        }
        do {
            let fetchedBooks = try await service.fetchBooks(for: subject)
            await MainActor.run {
                books = fetchedBooks
                CoreDataCacheManager.shared.saveBooks(fetchedBooks)
                isLoading = false
                showAlert = false
            }
        } catch {
            await MainActor.run {
                isLoading = false
                if let apiError = error as? BookAPIError {
                    alertMessage = apiError.description()
                } else {
                    alertMessage = "An unknown error occurred"
                }
                if let cachedBooks = CoreDataCacheManager.shared.loadBooks(), !cachedBooks.isEmpty {
                    books = cachedBooks
                    alertMessage += "\nShowing cached books."
                } else {
                    books = []
                    alertMessage += "\nNo cached data available."
                }
                showAlert = true
            }
        }
    }
    
}
