//
//  HomeTAbbarView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//

import Foundation
import SwiftUI

enum Tab {
    case home, create, profile
}

struct HomeTabbarView: View {
    @State private var selected: Tab = .home
    var body: some View {
          VStack(spacing: 0) {
              ZStack {
                  switch selected {
                  case .home:
                      PostHomeView()
                  case .create:
                      PostHomeView()
                  case .profile:
                      PostHomeView()
                  }
              }

              HStack {
//                  TabBarButton(tab: .home, selectedTab: $selectedTab, systemIcon: "house.fill", title: "Home")
//                  Spacer()
//                  TabBarButton(tab: .create, selectedTab: $selectedTab, systemIcon: "plus.app.fill", title: "Post")
//                  Spacer()
//                  TabBarButton(tab: .profile, selectedTab: $selectedTab, systemIcon: "person.fill", title: "Profile")
              }
              .padding()
              .background(Color(.systemGray6))
              .shadow(radius: 5)
          }
      }}
