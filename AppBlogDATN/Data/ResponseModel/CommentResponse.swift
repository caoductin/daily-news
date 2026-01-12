//
//  CommentResponse.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 28/5/25.
//

import Foundation

struct CommentResponse: Decodable, Equatable {
    let id: String
    let content: String
    let postId: String
    let userId: String
    let likes: [String]
    let numberOfLikes: Int
    let createdAt: String
    let updatedAt: String
    let userInfo: UserResponseComment?
    var isLikedByCurrentUser: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case content
        case postId
        case userId
        case likes
        case numberOfLikes
        case createdAt
        case updatedAt
        case userInfo = "user"
    }
    
    static func == (lhs: CommentResponse, rhs: CommentResponse) -> Bool {
        lhs.id == rhs.id
    }
}


struct UserResponseComment: Decodable, Equatable {
    let id: String
    let username: String
    let profilePicture: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case profilePicture
    }
}


struct CommentResquest: Encodable {
    var content: String
    var postId: String
    var userId: String
}

extension CommentResponse {
    func translate(_ targetLangue: String) async throws -> CommentResponse {
        func translateComment(_ text: String) async throws -> String {
            guard !text.isEmpty || !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                print("chuỗi rỗng")
                return text
            }
            return try await TranslateViewModel.shared.translateTemp(text: text, targetLanguage: targetLangue).translatedText
            
        }
        let translateResult = try await (
            translateComment(self.content)
        )
        
        print("this is comment \(translateResult)")
        return .init(id: id, content: translateResult, postId: postId, userId: userId, likes: likes, numberOfLikes: numberOfLikes, createdAt: createdAt, updatedAt: updatedAt, userInfo: userInfo, isLikedByCurrentUser: isLikedByCurrentUser)
    }

}
