//
//  SearchModule.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/6/26.
//

import SwiftUI

struct SearchModule: View {
    @State var seachCoordinator: SearchCoordinator

    var body: some View {
        NavigationStack(path: $seachCoordinator.path) {
//            PostHomeView()
//                .navigationDestination(for: SearchCoordinator.Screen.self) { screen in
//                    switch screen {
//                    case .postDetail(let postData):
//                        PostDetailView(post: postData)
//                    case .test:
//                        Text("Test")
//                    }
//                }
//                .navigationTitle("Search")
//                .navigationBarTitleDisplayMode(.large)
        }
        .environment(seachCoordinator)
    }
    
}
