//
//  UserModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 25/4/25.
//

import Foundation
//
//struct UserResponse: Codable {
//    let id: String
//    let username: String
//    let email: String
//    let profilePicture: String
//    let isAdmin: Bool
//    let createdAt: String
//    let updatedAt: String
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case username
//        case email
//        case profilePicture
//        case isAdmin
//        case createdAt
//        case updatedAt
//    }
//}
//
//struct AuthResponse: Decodable {
//    let accessToken: String
//    let user: UserResponse
//    enum CodingKeys: String, CodingKey {
//        case accessToken = "access_token"
//        case user
//    }
//}
//
//struct SignInRequest: Encodable {
//    var email: String
//    var password: String
//}
//
//struct SignUpRequest: Encodable {
//    let username: String
//    let email: String
//    let password: String
//}
//
//struct UserData {
//    let username: String
//    let email: String
//    let password: String
//}
//
//struct EmptyResponse: Codable {
//    
//}
//
//extension UserData {
//
//    static func setUser(userName: String, email: String, password: String) -> Self {
//        return .init(
//            username: userName,
//            email: email,
//            password: password
//        )
//    }
//}


//{
//    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4MjRiYTdmMTIxNTk2YWJiOGRmNzMwNSIsImlzQWRtaW4iOnRydWUsImlhdCI6MTc0ODM2MzI4M30.Yr91dWCLFWtA0PzlbFoOcul1MNMyEqF4SygxByA4fJU",
//    "user": {
//        "_id": "6824ba7f121596abb8df7305",
//        "username": "tuan",
//        "email": "tuan@gmail.com",
//        "profilePicture": "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
//        "isAdmin": true,
//        "createdAt": "2025-05-14T15:45:03.872Z",
//        "updatedAt": "2025-05-14T15:45:03.872Z",
//        "__v": 0
//    }
//}
import Foundation

// MARK: - Protocols

protocol UserRepresentable {
    var username: String { get }
    var email: String { get }
    var isAdmin: Bool { get }
}

// MARK: - Response Models

struct UserResponse: Codable, UserRepresentable {
    let id: String
    let username: String
    let email: String
    let profilePicture: String
    let isAdmin: Bool
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username
        case email
        case profilePicture
        case isAdmin
        case createdAt
        case updatedAt
    }
}

struct AuthResponse: Decodable {
    let accessToken: String
    let user: UserResponse
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case user
    }
}

// MARK: - Request Models

protocol AuthRequestRepresentable {
    var email: String { get }
    var password: String { get }
}

struct SignInRequest: Encodable, AuthRequestRepresentable {
    var email: String
    var password: String
}

struct SignUpRequest: Encodable, AuthRequestRepresentable {
    let username: String
    let email: String
    let password: String
}

struct UserData: AuthRequestRepresentable {
    var username: String
    var email: String
    var password: String
    
    static func setUser(userName: String, email: String, password: String) -> Self {
        .init(username: userName, email: email, password: password)
    }
}

// MARK: - Others

struct EmptyResponse: Codable {}
