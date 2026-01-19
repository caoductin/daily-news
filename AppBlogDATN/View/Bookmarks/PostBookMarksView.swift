import Observation
//
//  PostBookMarksView.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/11/26.
//
import SwiftUI

struct BookmarkView: View {
    @Environment(BookmarkCoordinator.self) private var bookmarkCoordinator
    @State private var viewModel: BookmarkViewModel
    @Namespace private var namespace
    
    init(viewModel: BookmarkViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                listPost
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
        .navigationTitle("Bookmark")
        .task {
            await viewModel.getPostBookmark()
        }
        .alert(
            "Error",
            isPresented: .constant(viewModel.isError)
        ) {
            Button("OK") {
                
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    @ViewBuilder
    private var listPost: some View {
        ForEach(viewModel.posts) { post in
            Button {
                openPostDetail(postData: post)
            } label: {
                rowPost(for: post)
            }
            .modifier(PressedScale(scale: 0.94))
        }
    }
    
    @ViewBuilder
    private func rowPost(for post: PostDetailModel) -> some View {
        ArticleCardView(
            post: post,
            onToggleBookmark: {
                Task {
                    await viewModel.toggleBookmarks(postId: post.id)
                }
            }
        )
        .scrollTransition { content, phase in
            content
                .opacity(phase.isIdentity ? 1 : 0.3)
                .scaleEffect(phase.isIdentity ? 1 : 0.8)
                .blur(radius: phase.isIdentity ? 0 : 2)
        }
        .onAppear {
            if post.id == viewModel.posts.last?.id {
                Task {
                    await viewModel.getPostBookmark()
                }
            }
        }
        .navigationTransition(.zoom(sourceID: post.id, in: namespace))
    }
    
    private func openPostDetail(postData: PostDetailModel) {
        bookmarkCoordinator.push(.postDetail(postData, namespace))
    }
}
