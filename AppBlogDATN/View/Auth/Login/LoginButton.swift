//
//  LoginButton.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/10/25.
//

import SwiftUI

struct LoginButton: ViewModifier {
    var backgroundColor: Color = .red
    var foregroundColor: Color = .white
    var borderWith: CGFloat = 2
    var borderColor: Color = Color(UIColor.systemGray4)
    func body(content: Content) -> some View {
        content
            .foregroundStyle(foregroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: borderWith)
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func loginButton() -> some View {
        modifier(LoginButton())
    }
}
