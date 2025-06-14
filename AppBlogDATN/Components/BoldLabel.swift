//
//  BoldLable.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/11/25.
//

import SwiftUI

struct BoldLabel: LabelStyle {
    var withIcon: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .scaledToFit()
                .frame(width: withIcon)
            configuration.title.bold()
        }
    }
}

extension LabelStyle where Self == BoldLabel {
    static func boldLabel(withIcon: CGFloat = 20) -> BoldLabel {
        BoldLabel(withIcon: withIcon)
    }
}

