//
//  BookCartApp.swift
//  BookCart
//
//  Created by Khushboo Barve on 17/07/2025.
//

import SwiftUI


@main
struct BookCartApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
