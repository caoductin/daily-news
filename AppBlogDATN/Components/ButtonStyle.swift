//
//  ButtonStyle.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/11/25.
//

import SwiftUI

struct CapsuButton: ButtonStyle {
    var backgroundColor: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }
}


extension ButtonStyle where Self == CapsuButton {
    static func blueButton() -> CapsuButton {
        CapsuButton(backgroundColor: .blue)
    }
}
