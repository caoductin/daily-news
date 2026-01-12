//
//  BookmarkStore.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/9/26.
//

import Foundation

@Observable
@MainActor
class PostStore {

    private(set) var postsById: [String: PostDetailModel] = [:]

    // MARK: - Write
    
    func remove(_ postId: String) {
        postsById.removeValue(forKey: postId)
    }
    
    func insert(_ post: PostDetailModel) {
        postsById[post.id] = post
    }

    func upsert(_ posts: [PostDetailModel]) {
        for post in posts {
            insert(post)
        }
    }
    
    func update(postId: String, transform: (inout PostDetailModel) -> Void) {
        guard var post = postsById[postId] else { return }
        transform(&post)
        postsById[postId] = post
    }

    // MARK: - Read

    func post(id: String) -> PostDetailModel? {
        postsById[id]
    }

    func posts(ids: [String]) -> [PostDetailModel] {
        ids.compactMap { postsById[$0] }
    }

    func allPosts() -> [PostDetailModel] {
        Array(postsById.values)
    }
}

