//
//  HomeModules.swift
//  AppBlogDATN
//
//  Created by TEAMS on 12/29/25.
//
import SwiftUI

struct HomeModule: View {
    @State var homeCoordinator: HomeCoordinator

    var body: some View {
        NavigationStack(path: $homeCoordinator.path) {
            HomeTabView()
                .navigationDestination(for: HomeCoordinator.Screen.self) { screen in
                    switch screen {
                    case .postDetail(let postData):
                        PostDetailView(post: postData)
                    case .test:
                        Text("Test")
                    }
                }
                .navigationBarTitleDisplayMode(.large)
        }
        .environment(homeCoordinator)

    }
    
}
