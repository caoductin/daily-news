//
//  TextFieldStyle.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/11/25.
//

import Foundation
import SwiftUI

struct OutlinedTextFieldStyle: TextFieldStyle {
    var backgroundOutline: Color
    var conrnerRadius: CGFloat = 16
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(maxWidth: .infinity)
            .padding(15)
            .overlay {
                RoundedRectangle(cornerRadius: conrnerRadius, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            }
    }
}

extension TextFieldStyle where Self == OutlinedTextFieldStyle {
    static func outline(cornerRadius: CGFloat = 16, backgroundOutline: Color = .blue) -> OutlinedTextFieldStyle {
        OutlinedTextFieldStyle(backgroundOutline: backgroundOutline, conrnerRadius: cornerRadius)
    }
}

