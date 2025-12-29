//
//  SettingModule.swift
//  AppBlogDATN
//
//  Created by TEAMS on 12/29/25.
//
import SwiftUI

struct SettingModule: View {
    @State var coordinator: SettingCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            SettingView()
                .environment(coordinator)
        }
        .navigationDestination(for: SettingCoordinator.Screen.self) { screen in
            switch screen {
            case .profile:
                ProfileView()
            case .createPost:
                PostCreateView()
            case .information:
                AppInformationView()
            case .language:
                LanguageSettingView()
            case .deletePost:
                PostDeleteView()
            }
        }
    }
}
