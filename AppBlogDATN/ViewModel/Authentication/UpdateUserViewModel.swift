//
//  UpdateUserViewModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 14/6/25.
//

import Foundation

@MainActor
class UpdateUserViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var userData: UserData?
    @Published var errorMessage: String?
    @Published var isError: Bool = false
    private let authService = AuthService()
    
    func updateUser() {
        isLoading = true
       
        userData = UserData.setUser(userName: "", email: email, password: password)
        guard let userData = userData else {
            errorMessage = "Please enter the fill"
            print("Please enter the fill")
            return
        }
        
        Task {
            defer {
                isLoading = false
            }
            do {
                let authenResponse = try await authService.signIn(userData: userData)
                UserManager.shared.login(authen: authenResponse)
            } catch {
                isError = true
                print("Login Failed: \(error.localizedDescription)")
                errorMessage = "Login Failed: \(error.localizedDescription)"
            }
        }
    }
}
