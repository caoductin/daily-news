//
//  PostDetailTable.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/8/26.
//

import Foundation
import SQLite

struct PostTable {
    static let table = Table("post")
    static let id = Expression<String>(value: "id")
    static let userId = Expression<String>(value: "userId")
    static let content = Expression<String>(value: "content")
    static let title = Expression<String>(value: "title")
    static let image = Expression<String>(value: "image")
    static let category = Expression<String>(value: "category")
    static let slug = Expression<String>(value: "slug")
    static let createdAt = Expression<String?>(value: "createdAt")
    static let updatedAt = Expression<String?>(value: "updateAt")
}
