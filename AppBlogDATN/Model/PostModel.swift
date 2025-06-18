//
//  PostModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 25/4/25.
//

import Foundation

struct PostDetailResponse: Decodable, Identifiable, Hashable {
    let id: String
    let userId: String
    let content: String
    let category: String
    let title: String
    let slug: String
    let image: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case content
        case category
        case slug
        case title
        case image
        case createdAt
        case updatedAt
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PostDetailResponse, rhs: PostDetailResponse) -> Bool {
        return lhs.id == rhs.id
    }
}

struct PostResponse: Decodable, Hashable {
    let posts: [PostDetailResponse]
    let totalPosts: Int
    let lastMonthPosts: Int
}

struct PostPaginatedResponse: Decodable {
    var posts: [PostDetailResponse]
    var currentPage: Int
    var totalPages: Int
    var totalPosts: Int
}

extension PostDetailResponse {
    func translate(_ targetLangue: String) async throws -> PostDetailResponse {
        func translatePost(_ text: String) async throws -> String {
            guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                print("chuỗi rỗng")
                return text
            }
            return try await TranslateViewModel.shared.translateTemp(text: text, targetLanguage: targetLangue).translatedText
            
        }
        let translateResult = try await (
            title: translatePost(self.title),
            category: translatePost(self.category),
            content: translatePost(self.content.htmlToPlainString().trimmingCharacters(in: .whitespacesAndNewlines)),
            slug: translatePost(self.slug)
        )
        
        print("this is translateResult \(translateResult)")
        return .init(id: UUID().uuidString, userId: userId, content: translateResult.content, category: translateResult.category, title: translateResult.title, slug: slug, image: image, createdAt: createdAt, updatedAt: updatedAt)
    }
}

//MARK: MOCK DATA

extension PostDetailResponse {
    static func mock(id: String = UUID().uuidString) -> PostDetailResponse {
        return PostDetailResponse(
            id: id,
            userId: "user_001",
            content: "Đây là nội dung bài viết demo dùng để test hiển thị trong UI.",
            category: "Science",
            title: "Gần 50% nhà nghiên cứu thế giới rời bỏ khoa học sau 10 năm",
            slug: "gian-50-nha-nghien-cuu-the-gioi-roi-bo-khoa-hoc",
            image: "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
            createdAt: "2023-06-01T10:00:00Z",
            updatedAt: "2023-06-02T10:00:00Z"
        )
    }
}
