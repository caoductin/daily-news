//
//  HomeTabView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//
import Foundation
import SwiftUI

struct PostHomeView: View {
    @Bindable var viewModel: HomePostViewModel
    @Environment(PostStore.self) private var postStore
    @Environment(HomeCoordinator.self) private var homeCoordinates

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.postIds, id: \.self) { id in
                    if let post = postStore.post(id: id) {
                        Button {
                            homeCoordinates.push(.postDetail(post))
                        } label: {
                            ArticleCardView(
                                post: post,
                                onToggleBookmark: {
                                    Task {
                                        await viewModel.toggleBookmark(postId: id)
                                    }
                                }
                            )
                            .onAppear {
                                Task { await viewModel.getPosts() }
                            }
                        }
                    }
                }
            }
        }
        .task {
            if viewModel.postIds.isEmpty {
                await viewModel.getPosts()
            }
        }
    }
}
