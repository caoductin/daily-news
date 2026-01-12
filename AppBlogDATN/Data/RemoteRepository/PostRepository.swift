//
//  PostRepository.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/7/26.
//

import Foundation

protocol PostRepository {
    func fetchPosts() async throws -> [PostDetailModel]

    func fetchPostsRelated(postId: String) async throws -> [PostDetailModel]

    func fetchPosts(
        category: Category?,
        page: Int,
        limit: Int
    ) async throws -> ([PostDetailModel], hasNext: Bool)
    
    func bookmarkPosts(
        postId: String
    ) async throws -> Bool
    
    func fetchBookMarks(
        page: Int,
        limit: Int
    ) async throws -> ([PostDetailModel], hasNext: Bool)
}
