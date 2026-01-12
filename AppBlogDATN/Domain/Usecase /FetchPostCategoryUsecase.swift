//
//  FetchPostsUseCase.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/7/26.
//

import Foundation

struct FetchPostCategory {
    let repository: PostRepository

    func execute(category: Category) async throws -> [PostDetailModel] {
        let posts = try await repository.fetchPosts()
        return posts
            .sorted { $0.createdAt > $1.createdAt }
    }
}

struct FetctPostRelatedUseCase {
    let repository: PostRepository
    
    func execute(postId: String) async throws -> [PostDetailModel] {
        let posts = try await repository.fetchPostsRelated(postId: postId)
        return posts
    }
}

struct FetchPostByCategoryUseCase {
    let repository: PostRepository
    
    func execute(category: Category?, page: Int,limit: Int = 10) async throws -> (posts: [PostDetailModel], hasNext: Bool) {
        let posts = try await repository.fetchPosts(
            category: category,
            page: page,
            limit: limit
        )
        return posts
    }
}
