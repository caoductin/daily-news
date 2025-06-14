//
//  HomeTabView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//
import Foundation
import SwiftUI

struct PostHomeView: View {
    @State var postViewModel = PostViewModel()
    
    var body: some View {
            ScrollView {
                LazyVStack {
                    ForEach(postViewModel.postsPaginated?.posts ?? []) { post in
                        NavigationLink(value: post) {
                            ArticleCardView(imageURL: post.image, title: post.title)
                                .overlay(
                                    Divider(), alignment: .bottom
                                )
                        }
                        .onAppear {
                            postViewModel.loadMoreContentIfNeeded(currentPost: post)
                        }
                    }
                    
                    if postViewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
            }
        .navigationDestination(for: PostDetailResponse.self) { post in
            PostDetailView(post: post)
        }
        .onAppear {
            postViewModel.initialLoadIfNeeded()
        }
    }
}


#Preview {
    NavigationStack {
        PostHomeView()
    }
}
