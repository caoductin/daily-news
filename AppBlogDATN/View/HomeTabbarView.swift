//
//  HomeTAbbarView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//

import Foundation
import SwiftUI

enum Tab: CaseIterable{
    case home, create ,bookmark ,setting
    
    var title: String {
        switch self {
        case .home:
            return "Home".localized
        case .create:
            return "Create"
        case .bookmark:
            return "Bookmark"
        case .setting:
            return "Setting"
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
        case .setting:
            return "gearshape"
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
                        HomeTabView()
                    case .create:
                        PostHomeView()
                    case .bookmark:
                        PostHomeView()
                    case .setting:
                        SettingView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .padding(.bottom, 70)
                
                CustomTabbar(selected: $selectedTab)
            }
            .background(Color(.systemGray6))
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
