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
    @State private var appCoordinator = AppCoordinator()
    var body: some View {
        NavigationStack {
            Group {
                if loginManager.isLogin {
                    HomeTabbarView()
                        .environment(appCoordinator)
                } else {
                    AuthPageView()
                }
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

