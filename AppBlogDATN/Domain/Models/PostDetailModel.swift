//
//  PostModel.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/7/26.
//
import SwiftUI

struct PostDetailModel: Identifiable, Hashable {
    let id: String
    let userId: String
    let content: String
    let category: Category
    let title: String
    let slug: String
    let image: URL?
    let createdAt: Date
    let updatedAt: Date
    var isBookmarked: Bool
}
