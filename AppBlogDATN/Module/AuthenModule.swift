//
//  AuthModule.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/13/26.
//

import Foundation

struct AuthenModule {
    @MainActor
    static func makeView() -> LoginView {
        let authRepository: AuthRepository = AuthRepositoryIlpm()
        let signInGoolgeUsecase = SignInGoogleUseCase(repository: authRepository)
        
        let viewModel = LoginViewModel(signInGoolgeUsecase: signInGoolgeUsecase)
        return LoginView(loginVM: viewModel)
    }
}
