//
//  UserModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 25/4/25.
//

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
