//
//  BookmarkModule.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/12/26.
//

import Foundation
import SwiftUI

struct BookmarkCoordinatorView: View {
    @Environment(PostStore.self) var postStore
    @State var bookmark: BookmarkCoordinator
    
    var body: some View {
        NavigationStack {
            BookmarkModule.makeView(postStore: postStore)
                .navigationDestination(for: BookmarkCoordinator.Screen.self) { screen in
                    switch screen {
                    case .postDetail(let postData):
                        PostDetailView(post: postData)
                    }
                }
                .environment(bookmark)
        }
    }
}
