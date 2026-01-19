//
//  AuthRepository.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/13/26.
//

import Foundation
import UIKit
import GoogleSignIn
import GoogleSignInSwift

protocol AuthRepository {
    func signInWithGoogle(presenting: UIViewController) async throws -> GoogleUser
    func loginWithGoolge(idToken: String) async throws -> AuthResponse
}

enum GoogleSignInError: Error {
    case invalidToken
    
    var localizeDesciption: String {
        switch self {
        case .invalidToken:
            "Invalid Token"
        }
    }
}

class AuthRepositoryIlpm: AuthRepository {
    func signInWithGoogle(presenting: UIViewController) async throws -> GoogleUser {

            let result = try await GIDSignIn.sharedInstance
                .signIn(withPresenting: presenting)
            
            guard let token = result.user.idToken?.tokenString else {
                throw GoogleSignInError.invalidToken
            }
            
            return GoogleUser(
                idToken: token,
                email: result.user.profile?.email,
                name: result.user.profile?.name
            )
    }
    
    func loginWithGoolge(idToken: String) async throws -> AuthResponse {
        let body: [String: Any] = [
            "idToken": idToken,
        ]
        let data = try await APIServices.shared.sendRequest(
            from: APIEndpoint.loginWithGoogle,
            type: AuthResponse.self,
            method: .POST,
            body: body
        )
        return data
    }
}

struct GoogleUser {
    let idToken: String
    let email: String?
    let name: String?
}
