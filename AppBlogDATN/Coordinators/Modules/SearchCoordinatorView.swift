//
//  SearchModule.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/6/26.
//

import SwiftUI

struct SearchCoordinatorView: View {
    @State var seachCoordinator: SearchCoordinator
    @Environment(PostStore.self) private var postStore

    var body: some View {
        NavigationStack(path: $seachCoordinator.path) {
            SearchModule.makeView(postStore: postStore)
                .navigationDestination(for: SearchCoordinator.Screen.self) { screen in
                    switch screen {
                    case .postDetail(let postData):
                        PostDetailView(post: postData)
                    case .test:
                        Text("Test")
                    }
                }
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.large)
        }
        .environment(seachCoordinator)
    }
    
}
