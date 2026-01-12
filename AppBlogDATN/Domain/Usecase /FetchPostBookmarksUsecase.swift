//
//  FetchPostBookmarks.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/9/26.
//

import Foundation

struct FetchPostBookmarksUsecase {
    let repository: PostRepository
    
    func execute(page: Int,limit: Int = 10) async throws -> (posts: [PostDetailModel], hasNext: Bool) {
        let posts = try await repository.fetchBookMarks(page: page, limit: limit)
        return posts
    }
}

struct MarkPostAsBookmarkUsecase {
    let repository: PostRepository
    
    func execute(id: String) async throws -> Bool{
        let data = try await repository.bookmarkPosts(postId: id)
        return data
    }
}
