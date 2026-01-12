//
//  PostDetailResponse.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/7/26.
//
import SwiftUI

struct CommentModel {
    let id: String
    let content: String
    let postId: String
    let userId: String
    let likes: [String]
    let numberOfLikes: Int
    let createdAt: Date?
    let updatedAt: Date?
    let userInfo: UserCommentModel?
    let isLikedByCurrentUser: Bool
}
