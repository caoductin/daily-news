//
//  CustomButton.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 25/4/25.
//

import Foundation
import SwiftUI

struct CustomButton: View {
    var title: String
    var icon: String? = nil
    var backgroundColor: Color = .blue
    var foregroundColor: Color = .white
    var cornerRadius: CGFloat = 12
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(cornerRadius)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}
#Preview{
    CustomButton(title: "Login button", icon: nil, backgroundColor: .blue, foregroundColor: .red, cornerRadius: 12) {
        print("cao duc tin")
    }
}
