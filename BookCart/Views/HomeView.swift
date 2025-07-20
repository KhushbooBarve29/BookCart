//
//  HomeView.swift
//  BookCart
//
//  Created by Khushboo Barve on 17/07/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = BookViewModel()
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                Text(viewModel.title)
                    .font(.largeTitle).bold()
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                Divider()
                    .padding(.bottom, 8)
                
                Group {
                    if viewModel.isLoading {
                        LoadingView()
                    } else if viewModel.books.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("No books available.")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 24) {
                                Text(viewModel.subTitle)
                                    .font(.title2)
                                    .bold()
                                    .padding(.horizontal)
                                
                                LazyVGrid(columns: columns, spacing: 24) {
                                    ForEach(viewModel.books) { book in
                                        NavigationLink(destination: DetailView(book: book)) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                AsyncImage(url: book.coverImageURL) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        Color.gray
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                    case .failure:
                                                        Image(systemName: "photo")
                                                            .resizable()
                                                            .foregroundColor(.gray)
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                .frame(width: 100, height: 150)
                                                .background(Color(.secondarySystemBackground))
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                                                )
                                            }
                                            .frame(width: 100)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top)
                        }
                    }
                }
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(
                        title: Text(viewModel.homeAlertTitle),
                        message: Text(viewModel.alertMessage),
                        dismissButton: .default(Text(viewModel.alertErrorButton))
                    )
                }
            }
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.loadBooks()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
