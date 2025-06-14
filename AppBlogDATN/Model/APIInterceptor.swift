//
//  APIInterceptor.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 27/5/25.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private var tokenKey = "access_token"

    var accessToken: String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func saveToken(token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }

    func clearToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    func refreshToken(completion: @escaping (Bool) -> Void) {
        completion(false)
    }
}
