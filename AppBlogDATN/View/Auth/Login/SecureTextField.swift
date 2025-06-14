//
//  SecureTextField.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/10/25.
//

import SwiftUI

struct SecureTextField: View {
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @FocusState private var isPasswordFieldFocused: Bool
    var body: some View {
        HStack {
            Group {
                if showPassword {
                    TextField("Password", text: $password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($isPasswordFieldFocused)
                } else {
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .focused($isPasswordFieldFocused)
                }
                Button(action: {
                    showPassword.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        isPasswordFieldFocused = true
                    }
                }) {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 50)
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(UIColor.systemGray4), lineWidth: 2)
        }
    }
}

#Preview {
    SecureTextField()
}
