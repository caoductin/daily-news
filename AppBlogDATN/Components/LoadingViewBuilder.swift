//
//  LoadingViewBuilder.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 12/6/25.
//

import SwiftUI

struct LoadingViewBuilder: ViewModifier {
    var isLoading: Bool
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 3 : 0)
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(3)
                    .tint(.white)
            }
        }
    }
}

extension View {
    func loadingViewBuilder(isLoading: Bool) -> some View {
        self.modifier(LoadingViewBuilder(isLoading: isLoading))
    }
}
