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
    
    @Namespace var namespace
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.postIds, id: \.self) { id in
                    if let post = postStore.post(id: id) {
                        PostRow(
                            post: post,
                            onSelected: { post in
                                homeCoordinates.push(
                                    .postDetail(post, namespace))
                            },
                            onToggleBookmark: {
                                onToggle(id: id)
                            },
                            ns: namespace
                        )
                        .onAppear {
                            guard !viewModel.isLoading else { return }
                            if id == viewModel.postIds.last {
                                Task { await viewModel.getPosts() }
                            }
                        }
                    }
                }
            }
        }
        .refreshable {
            await viewModel.getPosts(isRefresh: true)
        }
        .animation(
            .spring(response: 0.45, dampingFraction: 0.85),
            value: viewModel.postIds
        )
        .task {
            if viewModel.postIds.isEmpty {
                await viewModel.getPosts()
            }
        }
    }
    
    private func onToggle(id: String) {
        Task {
            await viewModel.toggleBookmark(postId: id)
        }
    }
    
}

struct PostRow: View {
    let post: PostDetailModel
    let onSelected: (PostDetailModel) -> Void
    let onToggleBookmark: () -> Void
    let ns: Namespace.ID
    var body: some View {
        Button {
            onSelected(post)
        } label: {
            ArticleCardView(
                post: post,
                onToggleBookmark: onToggleBookmark
            )
            .scrollTransition { content, phase in
                content
                    .opacity(phase.isIdentity ? 1 : 0.3)
                    .scaleEffect(phase.isIdentity ? 1 : 0.8)
                    .blur(radius: phase.isIdentity ? 0 : 2)
            }
            .navigationTransition(.zoom(sourceID: post.id, in: ns))
        }
        .modifier(PressedScale(scale: 0.94))
    }
    
}
