//
//  HomeTAbbarView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//

import Foundation
import SwiftUI

enum TabIndentifi: CaseIterable {
    case home, search, bookmark, setting

    var title: String {
        switch self {
        case .home:
            return "Home".localized
        case .search:
            return "Search"
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
        case .search:
            return "magnifyingglass.circle"
        case .bookmark:
            return "bookmark.fill"
        case .setting:
            return "gearshape"
        }
    }
}

struct HomeTabbarView: View {
    @Environment(AppCoordinator.self) private var coordinator
    @Environment(PostStore.self) private var postStore
    @State private var selectedTab: TabIndentifi = .home

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case .home:
                    HomeModule(homeCoordinator: coordinator.homeCoordinator)
                        .environment(coordinator.homeCoordinator)

                case .search:
                    SearchCoordinatorView(seachCoordinator: coordinator.searchCoordinator)
                case .bookmark:
                    BookmarkCoordinatorView(bookmark: coordinator.bookMarkCoordinator)

                case .setting:
                    SettingModule(coordinator: coordinator.settingCoordinator)
                }
            }

            Spacer()

            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabIndentifi
    @Namespace private var animation

    var body: some View {
        HStack {
            ForEach(TabIndentifi.allCases, id: \.self) { tab in
                tabButton(tab)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.systemBackground))
                .shadow(radius: 5)
        )
        .padding(.horizontal)
    }

    @ViewBuilder
    private func tabButton(_ tab: TabIndentifi) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: .semibold))
            }
            .foregroundColor(selectedTab == tab ? .blue : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                backgroundTab(tab)
            )
        }
    }

    @ViewBuilder
    private func backgroundTab(_ tab: TabIndentifi) -> some View {
        ZStack {
            if selectedTab == tab {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.accentColor.opacity(0.15))
                    .matchedGeometryEffect(id: "TAB_BG", in: animation)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeTabbarView()
            .environment(AppCoordinator())
    }
}
