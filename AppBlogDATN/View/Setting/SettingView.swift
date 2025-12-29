//
//  SettingView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 12/6/25.
//

import SwiftUI
import Translation
struct SettingView: View {
    @Environment(SettingCoordinator.self) private var settingCoordinator
    let isLogin = UserManager.shared.isLogin
    var body: some View {
        VStack {
            List {
                ForEach([SettingCategory.general, .posts, .account], id: \.self) { category in
                    let options = SettingOptions.allCases.filter { $0.category == category }
                    Section(header: Text(category.title)
                        .font(.headline)
                        .foregroundColor(.gray)
                    ) {
                        ForEach(options) { option in
                            LabelItem(option: option)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .background(.red)
            FooterView()
        }
    }
    
    @ViewBuilder
    func FooterView() -> some View {
        Button {
            if isLogin {
                UserManager.shared.logout()
            } else {
                //navigation to post
            }
            
        } label: {
            Text(isLogin ? "Logout" : "Sign up")
                .font(.headline)
        }
        .padding(.horizontal, 16)
        .buttonStyle(BorderButton(backgroundColor: .blue))
    }
    
    @ViewBuilder
    func LabelItem(option: SettingOptions) -> some View {
        Button {
            settingCoordinator.push(.language)
        } label: {
            Label(option.title, systemImage: option.icons)
                .fontDesign(.rounded)
                .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        let settingCoordinator = SettingCoordinator()
        SettingModule(coordinator: settingCoordinator)
            .environment(SettingCoordinator())
    }
}

enum SettingCategory: String, CaseIterable, Identifiable {
    case general
    case posts
    case account
    
    var id: String {
        rawValue
    }
    
    var title: String {
        switch self {
        case .account: "Account"
        case .posts: "Posts"
        case .general: "General"
        }
    }
}

enum SettingOptions: String, CaseIterable, Identifiable {
    case language
    case information
    case createPost
    case userInfo
    case managerPost
    
    var id: String { title }
    
    var title: String {
        switch self {
        case .language:
            "Language"
        case .information:
            "Information"
        case .createPost:
            "Create Post"
        case .managerPost:
            "Manage Post"
        case .userInfo:
            "User Info"
        }
    }
    
    var category: SettingCategory {
        switch self {
        case .userInfo:
            return .account
        case .language, .information:
            return .general
        case .createPost, .managerPost:
            return .posts
        }
    }
    
    var icons: String {
        switch self {
        case .language:
            "globe"
        case .information:
            "info.circle"
        case .createPost:
            "square.and.arrow.down.fill"
        case .managerPost:
            "trash"
        case .userInfo:
            "person.fill"
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .userInfo:
            ProfileView()
        case .language:
            LanguageSettingView()
        case .information:
            AppInformationView()
        case .createPost:
            PostCreateView()
        case .managerPost:
            PostDeleteView()
        }
    }
}

