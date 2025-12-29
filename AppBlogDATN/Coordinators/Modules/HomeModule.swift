//
//  HomeModules.swift
//  AppBlogDATN
//
//  Created by TEAMS on 12/29/25.
//
import SwiftUI

struct HomeModule: View {
    @State var coordinator: HomeCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeTabView()
                .environment(coordinator)
        }
        .navigationDestination(for: HomeCoordinator.Screen.self) { screen in
            switch screen {
            case .postDetail(let postDetail):
                PostDetailView(post: postDetail)
            }
        }
    }
    
}
