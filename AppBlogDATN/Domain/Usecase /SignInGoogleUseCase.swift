//
//  SignInGoogleUseCase.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/13/26.
//

import Foundation
import UIKit


struct SignInGoogleUseCase {
    let repository: AuthRepository
    
    func execute(presenting: UIViewController) async throws -> AuthResponse {
        let googleUser = try await repository.signInWithGoogle(presenting: presenting)
        print("this is token \(googleUser.idToken)")
        let data = try await repository.loginWithGoolge(idToken: googleUser.idToken)
        return data
    }
}
