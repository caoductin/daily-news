//
//  UserViewModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 31/5/25.
//

import Foundation

class UserManager: ObservableObject {
    @Published var currentUser: UserResponse?
    @Published var isLogin = false
    
    static let shared = UserManager()
    
    private var authenService = AuthService()
    private var tokenManager = TokenManager.shared
    private let userKey = "userKey"
    
    func login(authen: AuthResponse) {
        currentUser = authen.user
        tokenManager.saveToken(token: authen.accessToken)
        saveUserToStorage(user: authen.user)
    }
    
    func loadUser() {
        if (TokenManager.shared.accessToken != nil) {
            isLogin = true
            getUserFromStorage()
        }
    }
    
    func logout() {
        currentUser = nil
        isLogin = false
        tokenManager.clearToken()
        clearUserStorage()
    }
    
    private func saveUserToStorage(user: UserResponse) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    private func getUserFromStorage() {
        if let userInfo = UserDefaults.standard.data(forKey: userKey),
           let userStorage = try? JSONDecoder().decode(UserResponse.self, from: userInfo) {
            currentUser = userStorage
        }
    }
    
    private func clearUserStorage() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
