//
//  DetailView.swift
//  BookCart
//
//  Created by Khushboo Barve on 17/07/2025.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel = BookViewModel()
    let book: Book
    
    @State private var showAlert = false
    @State private var errorMessage: String?
    @State private var cachedImage: UIImage?
    @State private var isLoading = true
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            if !showAlert {
                if isLoading {
                    VStack {
                        Spacer()
                        LoadingView()
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            if let uiImage = cachedImage {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)
                                    .cornerRadius(12)
                            }
                            
                            Text(book.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            if !book.authorName.isEmpty {
                                Text("by \(book.authorName)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle(viewModel.titleHeader)
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(viewModel.alertErrorTitle),
                message: Text(errorMessage ?? viewModel.alertErrorMessage),
                dismissButton: .default(Text(viewModel.alertErrorButton)) {
                    // Goes to previous screen on alert dismiss
                    dismiss()
                }
            )
        }
        .onAppear {
            loadBookImage()
        }
    }
    
    private func loadBookImage() {
        if let image = CoreDataCacheManager.shared.loadImage(for: book.key) {
            cachedImage = image
            isLoading = false
            return
        }
        
        guard let url = book.coverImageURL else {
            errorMessage = "Image URL is missing."
            showAlert = true
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = error.localizedDescription
                    showAlert = true
                } else if let data = data, let image = UIImage(data: data) {
                    CoreDataCacheManager.shared.saveImage(image, for: book.key)
                    cachedImage = image
                    isLoading = false
                } else {
                    errorMessage = "Failed to load image."
                    showAlert = true
                }
            }
        }.resume()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockBook = Book(
            key: "OL12345M",
            title: "Sample Book Title",
            cover_id: 101,
            authors: [Author(name: "Sample Author")]
        )
        
        DetailView(book: mockBook)
            .preferredColorScheme(.dark)
    }
}
