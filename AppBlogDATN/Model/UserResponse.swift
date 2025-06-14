//
//  UserModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 25/4/25.
//

import Foundation

struct UserResponse: Codable {
    let id: String
    let username: String
    let email: String
    let passwrod: String
    let profilePicture: String
    let isAdmin: String
    let createdAt: String
    let updatedAt: String
}

struct AuthResponse: Decodable {
    let accessToken: String
    let user: UserResponse
}

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
