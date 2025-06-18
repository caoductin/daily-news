//
//  ContentView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("appLanguage") var appLanguage: String = "vi"
    @StateObject var loginManager = UserManager.shared
    @State private var reloadID = UUID()

    var body: some View {
        NavigationStack {
            Group {
//                if loginManager.isLogin {
                if let url = URL(string: "https://sharelatex-wiki-cdn-671420.c.cdn77.org/learn-scripts/images/5/5f/Ragged2eOLV21.png") {
                    ImageTranslateView(imageURL: url)
                } else {
                    Text("URL không hợp lệ")
                }
//                } else {
//                    AuthPageView()
//                }
            }
            .id(reloadID)
        }
        .onAppear {
            LocalizationManager.shared.setLanguage(appLanguage)
        }
        .onReceive(NotificationCenter.default.publisher(for: .languageChanged)) { _ in
            reloadID = UUID()
        }
    }
}

#Preview {
    ContentView()
}

