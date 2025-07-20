//
//  MainTabView.swift
//  BookCart
//
//  Created by Khushboo Barve on 19/07/2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SettingView()
                .tabItem {
                    Label("My Books", systemImage: "book")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
