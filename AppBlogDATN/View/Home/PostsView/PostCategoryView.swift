//
//  PostByCategory.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/8/26.
//

import Foundation

import SwiftUI

struct PostCategoryView: View {
    @Environment(HomeCoordinator.self) private var homeCoordinates
    @Bindable var postCategoryVM: PostByCategoryViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(postCategoryVM.posts) { post in
                    Button(action: {
                        homeCoordinates.push(.postDetail(post))
                    }, label: {
                        ArticleCardView(post: post, onToggleBookmark: {
                            Task {
                                await postCategoryVM.toggleBookmark(postId: post.id)
                            }
                        })
                        .onAppear {
                            Task {
                                await postCategoryVM.getPostsCategory()
                            }
                        }
                    })
                }
                if postCategoryVM.isLoading {
                    ProgressView()
                }
            }
        }
        .onAppear {
            Task {
                await postCategoryVM.getPostsCategory()
            }
        }
    }
}
