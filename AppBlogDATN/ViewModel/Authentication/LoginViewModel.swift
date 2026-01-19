//
//  LoginViewModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 10/6/25.
//

import Foundation
import UIKit

@MainActor
@Observable
class LoginViewModel {
    var email = ""
    var password = ""
    var isLoading = false
    var userData: UserData?
    var errorMessage: String?
    var isError: Bool = false
    
    private let authService = AuthService()
    private let signInGoogleUseCase: SignInGoogleUseCase
    
    init(signInGoolgeUsecase: SignInGoogleUseCase ) {
        self.signInGoogleUseCase = signInGoolgeUsecase
    }
    
    func login() {
        isLoading = true
        
        userData = UserData.setUser(userName: "", email: email, password: password)
        guard let userData = userData else {
            errorMessage = "Please enter the fill"
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
    
    func signInGoogle(presenting: UIViewController) async {
        do {
            let data = try await signInGoogleUseCase.execute(presenting: presenting)
            UserManager.shared.login(authen: data)
        } catch {
            print("this is error\(error)")
        }
    }
    
}
