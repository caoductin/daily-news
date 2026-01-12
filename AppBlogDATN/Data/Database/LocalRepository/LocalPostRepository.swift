//
//  PostLocalRepository.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/8/26.
//

import Foundation
import SQLite


final class LocalPostRepository {
    private let db = DatabaseManager.shared.db
 
    func insert(_ post: PostDetailModel) {
        let insert = PostTable.table.insert(
            PostTable.id <- post.id,
            PostTable.content <- post.content,
            PostTable.category <- post.category.rawValue,
            PostTable.title <- post.title,
            PostTable.slug <- post.slug,
            PostTable.image <- post.image?.absoluteString ?? "",
            PostTable.createdAt <- post.createdAt.isoString,
            PostTable.updatedAt <- post.updatedAt.isoString
        )
    }
        
    func deleteAll(_ post: String) {
        
    }
}

extension Date {
    static let isoFormatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    var isoString: String {
        Date.isoFormatter.string(from: self)
    }
}
