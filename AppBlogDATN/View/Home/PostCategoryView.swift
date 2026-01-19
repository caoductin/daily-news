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
    @Namespace var namespace
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(postCategoryVM.posts) { post in
                    PostRow(
                        post: post,
                        onSelected: { post in
                            homeCoordinates.push(.postDetail(post, namespace))
                        },
                        onToggleBookmark: {
                            toggleBookmark(id: post.id)
                        }, ns: namespace
                    )
                    .onAppear {
                        Task {
                            await postCategoryVM.getPostsCategory()
                        }
                    }
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

    private func toggleBookmark(id: String) {
        Task {
            await postCategoryVM.toggleBookmark(postId: id)
        }
    }
}
