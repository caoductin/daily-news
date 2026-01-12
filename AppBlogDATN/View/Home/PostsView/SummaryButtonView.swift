//
//  Untitled.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 22/6/25.
//

import SwiftUI

struct SummaryDialogView: View {
    let summaryText: String?
    @Binding var isPresented: Bool
    @State private var summaryTextHeight: CGFloat = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }

            VStack {
                Text("Summary of content")
                    .font(.headline)
                    .padding(.top)

                Group {
                    if summaryTextHeight > UIScreen.main.bounds.height * 0.5 {
                        ScrollView {
                            Text(summaryText ?? "")
                                .padding()
                                .readHeight()
                        }
                        .frame(height: UIScreen.main.bounds.height * 0.5)
                    } else {
                        Text(summaryText ?? "")
                            .padding()
                            .readHeight()
                    }
                }
                .onPreferenceChange(ViewHeightKey.self) { height in
                    summaryTextHeight = height
                }

                Button("Close") {
                    withAnimation {
                        isPresented = false
                    }
                }
                .buttonStyle(.blueButton())
                .padding(.bottom)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(.white))
            .padding(30)
        }
    }
}

struct SummaryButtonView: View {
    @Binding var summaryText: String?
    @Binding var isSummarizing: Bool
    var summaryTextAction: (() -> Void)?

    var body: some View {
        Button(action: {
            isSummarizing = true
            summaryTextAction?()
        }) {
            ZStack {
                if isSummarizing {
                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                   startPoint: .leading,
                                   endPoint: .trailing)
                        .frame(height: 50)
                        .cornerRadius(12)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        )
                } else {
                    Text("Text summary")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
        }
    }
}




struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct HeightReader: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: ViewHeightKey.self, value: proxy.size.height)
                }
            )
    }
}
extension View {
    func readHeight() -> some View {
        self.modifier(HeightReader())
    }
}
