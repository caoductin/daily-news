//
//  FooterLoginView.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/10/25.
//

import SwiftUI

struct FooterLoginView: View {
    @State var loginApple: (() -> ())?
    @State var loginGoogle: (() -> ())?
    var body: some View {
        Button {
            loginApple?()
        } label: {
            Label("Login with apple", systemImage: "apple.logo")
                .modifier(LoginButton(backgroundColor: .white,
                                      foregroundColor: .black,
                                      borderWith: 4))
        }
        .labelStyle(.boldLabel())
        
        Button {
            loginGoogle?()
        } label: {
            Label {
                Text("Continue with Google")
            } icon: {
                Image("google_icon")
                    .resizable()
            }
            .modifier(LoginButton(backgroundColor: .white,
                                  foregroundColor: .black,
                                  borderWith: 4))
        }
        .labelStyle(.boldLabel())
    }
}

#Preview {
    FooterLoginView()
}
