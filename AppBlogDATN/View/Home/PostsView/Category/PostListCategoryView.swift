//
//  PostListCategoryView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 15/6/25.
//

import SwiftUI

struct PostListCategoryView: View {
    var postListView: [PostDetailModel] = []
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(postListView) { post in
                    NavigationLink(value: post) {
                        ArticleCardView(post: post)
                            .overlay(
                                Divider(), alignment: .bottom
                            )
                    }
                }
            }
        }
        .navigationDestination(for: PostDetailModel.self) { post in
            PostDetailView(post: post)
        }
    }
}


#Preview {
    PostListCategoryView()
}
