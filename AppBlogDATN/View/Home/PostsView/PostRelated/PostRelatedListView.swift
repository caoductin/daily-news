//
//  PostRelatedListView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 7/6/25.
//

import SwiftUI

struct PostRelatedListView: View {
    @ObservedObject var viewModel: PostRelatedViewModel
    @State private var selectedPost: PostDetailResponse?
    var onSelect: ((PostDetailResponse) -> Void)? = nil
    
    
    var body: some View {
        VStack(alignment: .leading) {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(viewModel.postsRelated) { postRelated in
                    Button {
                        selectedPost = postRelated
                    } label: {
                        PostRelatedView(postRelated: postRelated)
                    }
                }
            }
        }
        .navigationDestination(item: $selectedPost) { post in
                PostDetailView(post: post)
            }
    }
}

