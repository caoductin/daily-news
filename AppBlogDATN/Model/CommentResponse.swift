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

//
//[
//    {
//        "_id": "6834ad6d529b3e5b6fe6b76e",
//        "content": "bài viết hay quá",
//        "postId": "6824be39121596abb8df7348",
//        "userId": "6824ba7f121596abb8df7305",
//        "likes": [
//            "6824ba7f121596abb8df7305"
//        ],
//        "numberOfLikes": 1,
//        "createdAt": "2025-05-26T18:05:33.267Z",
//        "updatedAt": "2025-05-26T18:05:36.055Z",
//        "__v": 1,
//        "user": {
//            "_id": "6824ba7f121596abb8df7305",
//            "username": "tuan",
//            "profilePicture": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"
//        }
//    }
//]
