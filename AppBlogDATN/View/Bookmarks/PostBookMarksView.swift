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
        .onAppear {
            if post.id == viewModel.posts.last?.id {
                Task {
                    await viewModel.getPostBookmark()
                }
            }
        }
    }
    
    private func openPostDetail(postData: PostDetailModel) {
        print("This icall")
        bookmarkCoordinator.push(.postDetail(postData))
    }
}
