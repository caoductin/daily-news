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


struct LoadingView: View {
    @Binding var isLoading: Bool
    var message: String = "Đang tải..."
    var backgroundColor: Color = Color.black.opacity(0.4)

    var body: some View {
        if isLoading {
            ZStack {
                backgroundColor
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)

                    Text(message)
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding(24)
                .background(Color.black.opacity(0.7))
                .cornerRadius(12)
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.25), value: isLoading)
        }
    }
}

extension View {
    func withLoadingOverlay(_ isLoading: Binding<Bool>, message: String = "Đang tải...") -> some View {
        ZStack {
            self
            LoadingView(isLoading: isLoading, message: message)
        }
    }
}
