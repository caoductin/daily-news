//
//  PostMapper.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/7/26.
//

import Foundation

extension PostDetailResponse {
    func toDomain() -> PostDetailModel {
        PostDetailModel(
            id: id,
            userId: userId,
            content: content,
            category: Category(apiValue: category),
            title: title,
            slug: slug,
            image: URL(string: image),
            createdAt: createdAt.toDate() ?? .now,
            updatedAt: updatedAt.toDate() ?? .now,
            isBookmarked: isBookmarked
        )
    }
}
