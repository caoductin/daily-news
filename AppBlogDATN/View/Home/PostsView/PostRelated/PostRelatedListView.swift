//
//  PostRelatedListView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 7/6/25.
//

import SwiftUI

struct PostRelatedListView: View {
    @ObservedObject var viewModel: PostRelatedViewModel
    @State private var selectedPost: PostDetailModel?
    var onSelect: ((PostDetailResponse) -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Related Posts")
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVStack(spacing: 16) {
                ForEach(viewModel.postsRelated) { postRelated in
                    Button {
                        selectedPost = postRelated
                    } label: {
                        PostRelatedView(
                            postRelated: postRelated,
                            onToggleBookmark: {
                                Task {
                                    await viewModel.toggleBookmark(postId: postRelated.id)
                                }
                            }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationDestination(item: $selectedPost) { post in
            PostDetailView(post: post)
        }
    }
}
