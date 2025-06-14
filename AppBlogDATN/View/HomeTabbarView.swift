//
//  HomeTAbbarView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//

import Foundation
import SwiftUI

enum Tab: CaseIterable{
    case home, create , profile, bookmark
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .create:
            return "Create"
        case .profile:
            return "profile"
        case .bookmark:
            return "bookmark"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .create:
            return "folder.badge.plus"
        case .bookmark:
            return "person.crop.circle.fill"
        case .profile:
            return "person.crop.circle.fill"
        }
    }
}

struct HomeTabbarView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom) {
                Group {
                    switch selectedTab {
                    case .home:
                        PostHomeView()
                    case .create:
                        PostHomeView()
                    case .bookmark:
                        SettingView()
                    case .profile:
                        ProfileView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .padding(.bottom, 70)
                
                CustomTabbar(selected: $selectedTab)
            }
            .background(Color(.systemGray6))
            .shadow(radius: 5)
        }
    }
}

#Preview {
    HomeTabbarView()
}

struct CustomTabbar: View {
    @Binding var selected:Tab
    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                TabBarButton(icon: tab.icon, tab: tab, title: tab.title, selectedTab: $selected)
            }
        }
        .padding(.top,5)
        .background()
    }
}
