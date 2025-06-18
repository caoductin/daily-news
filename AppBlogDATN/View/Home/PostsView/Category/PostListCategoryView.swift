//
//  PostListCategoryView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 15/6/25.
//

import SwiftUI

struct PostListCategoryView: View {
    var postListView: [PostDetailResponse] = []
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(postListView) { post in
                    NavigationLink(value: post) {
                        ArticleCardView(imageURL: post.image, title: post.title)
                            .overlay(
                                Divider(), alignment: .bottom
                            )
                    }
                }
            }
        }
        .navigationDestination(for: PostDetailResponse.self) { post in
            PostDetailView(post: post)
        }
    }
}


#Preview {
    PostListCategoryView()
}
