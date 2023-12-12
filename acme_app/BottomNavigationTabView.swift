//
//  BottomNavigationTabView.swift
//  acme_app
//
//  Created by Arup Sarkar on 12/11/23.
//  Copyright © 2023 acme_appOrganizationName. All rights reserved.
//

import SwiftUI

struct BottomNavigationTabView: View {
    var body: some View {
        TabView {
            ColorGameView()
                .tabItem {
                    Label("Game", systemImage: "gamecontroller.fill")
                }
            MerchandiseView()
                .tabItem {
                    Label("Merch", systemImage: "bag.fill")
                }
            UnifiedProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

//#Preview {
//    BottomNavigationTabView()
//}
