//
//  CommentMapper.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/7/26.
//

import Foundation

extension CommentResponse {
    func toDomain() -> CommentModel {
        .init(
            id: self.id,
            content: self.content,
            postId: self.postId,
            userId: self.userId,
            likes: self.likes,
            numberOfLikes: self.numberOfLikes,
            createdAt: self.createdAt.toDate(),
            updatedAt: self.updatedAt.toDate(),
            userInfo: self.userInfo?.toDomain(),
            isLikedByCurrentUser: self.isLikedByCurrentUser
        )
    }
}
