//
//  SignUpView.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/11/25.
//

import SwiftUI

struct SignUpView: View {
    @State var userName: String = ""
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 8) {
                    Text("User name")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("User name", text: $userName)
                        .textFieldStyle(.outline())
                    
                    Text("Email")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Email", text: $userName)
                        .textFieldStyle(.outline())
                    
                    Text("Password")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Conform password")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
//                    SecureTextField()
                }
                
                DividerView()
                
                Button("Register") {
                    
                }.buttonStyle(BorderButton(backgroundColor: .primaryColor, cornerRadius: 16))
                VStack {
                    FooterLoginView()
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

#Preview{
    SignUpView()
}
