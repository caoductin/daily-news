//
//  UserCommentMapper.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/7/26.
//

import Foundation

extension UserResponseComment {
    func toDomain() -> UserCommentModel {
        .init(
            id: self.id,
            username: self.username,
            profilePicture: URL(string: self.profilePicture)
        )
    }
}
