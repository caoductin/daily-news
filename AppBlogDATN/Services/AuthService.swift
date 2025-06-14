//
//  AuthService.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 9/6/25.
//

import Foundation

class AuthService {
    
    func signIn(userData: UserData) async throws -> AuthResponse {
        let body = SignInRequest(email: userData.email, password: userData.password)
        print("this is body\(body) ")
        let data = try await APIServices.shared.sendRequest(
            from: "/api/auth/signin",
            type: AuthResponse.self,
            method: .POST,
            body: body)
        print("this is data \(data)")
        return data
    }
    
    func signUp(userData: UserData) async throws -> EmptyResponse {
        let body = SignUpRequest(
            username: userData.username,
            email: userData.email,
            password: userData.password)
        
        let signupData = try await APIServices.shared.sendRequest(
            from: "/api/auth/signin",
            type: EmptyResponse.self,
            method: .POST,
            body: body)
        
        return signupData
    }
    
}
