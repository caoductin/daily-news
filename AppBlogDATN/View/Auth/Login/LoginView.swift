//
//  WelcomeView.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/10/25.
//

import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

struct LoginView: View {
    @State var loginVM: LoginViewModel
    @StateObject var loginManager = UserManager.shared
    var body: some View {
        VStack(spacing: 24) {
            VStack {
                Text("Your Email")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Enter your email", text: $loginVM.email)
                    .frame(height: 50)
                    .textFieldStyle(.outline())
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .previewLayout(.sizeThatFits)

                Text("Password")
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                SecureTextField(password: $loginVM.password)
            }

            Button("Continue") {
                loginVM.login()
            }.buttonStyle(
                BorderButton.style(
                    backgroundColor: .primaryColor, cornerRadius: 10))

            DividerView()
            VStack(spacing: 10) {
                FooterLoginView(loginGoogle:  {
                    handleSignInGoolge()
                })
            }
        }
        .blur(radius: loginVM.isLoading ? 3 : 0)
        .padding()
        .alert(
            "Login Failed", isPresented: $loginVM.isError,
            actions: {
                Button("OK", role: .cancel) {
                    loginVM.isError = false
                }
            },
            message: {
                Text(loginVM.errorMessage ?? "Unknown error")
            })
    }

    private func handleSignInGoolge() {
        Task { @MainActor in
            guard let vc = getRootViewController() else { return }
            await loginVM.signInGoogle(presenting: vc)
        }
    }

    func getRootViewController() -> UIViewController? {
        UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController
    }
}
//
//#Preview {
//    NavigationStack {
//        LoginView()
//    }
//
//}

struct BorderButton: ButtonStyle {
    var backgroundColor: Color
    var cornerRadius: CGFloat = 8
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(backgroundColor)
            )
    }

    static func style(backgroundColor: Color = .blue, cornerRadius: CGFloat = 8)
        -> BorderButton
    {
        BorderButton(
            backgroundColor: backgroundColor, cornerRadius: cornerRadius)
    }

}
