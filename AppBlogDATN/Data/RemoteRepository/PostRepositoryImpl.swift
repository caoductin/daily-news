//
//  PostRepositoryImpl.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/7/26.
//

import Foundation

struct PostRepositoryImpl: PostRepository {
    
    func fetchPosts(category: Category?, page: Int, limit: Int) async throws -> ([PostDetailModel], hasNext: Bool) {
        let data = try await APIServices.shared.sendRequest(
            from: APIEndpoint.getPostByCategory(
                category: category,
                currentPage: (page - 1) * limit,
                limit: limit
            ),
            type: PostsResponse.self,
            method: .GET
            )
        let post = data.posts.map{ $0.toDomain()}
        return (post, data.pagination.hasNext)
    }
    
    
    func fetchPosts() async throws -> [PostDetailModel] {
        let data = try await APIServices.shared.sendRequest(
            from: APIEndpoint.getPosts,
            type: PostResponse.self,
            method: .GET
        )
        return data.posts.map { $0.toDomain() }
    }
    
    func fetchPostsRelated(postId: String) async throws -> [PostDetailModel] {
        let data = try await APIServices.shared.sendRequest(
            from: APIEndpoint.getPostsRelated(postId: postId),
            type: [PostDetailResponse].self,
            method: .GET
        )
        return data.map { $0.toDomain() }
    }
    
    func bookmarkPosts(postId: String) async throws -> Bool {
        let body: [String: Any] = [
            "postId": postId
        ]
        let data = try await APIServices.shared.sendRequest(
            from: APIEndpoint.bookmark,
            type: BookmarkResponse.self,
            method: .POST,
            body: body
        )
        return data.bookmarked
    }
    
    func fetchBookMarks(page: Int, limit: Int) async throws -> ([PostDetailModel], hasNext: Bool) {
        let data = try await APIServices.shared.sendRequest(
            from: APIEndpoint.getBookmarks(startndex: (page - 1) * limit, limit: limit),
            type: PostsResponse.self,
            method: .GET
        )
        let post = data.posts.map { $0.toDomain() }
        return (post, data.pagination.hasNext)
    }

}
