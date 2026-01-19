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
                ForEach(
                    [SettingCategory.general, .posts, .account], id: \.self
                ) { category in
                    let options = SettingOptions.allCases.filter {
                        $0.category == category
                    }
                    Section(
                        header: Text(category.title)
                            .font(.headline)
                            .foregroundColor(.gray)
                    ) {
                        ForEach(options) { option in
                            LabelItem(option: option)
                        }
                    }
                }
                LogoutSection()
            }
            .listStyle(.grouped)
            .background(.red)
        }
        .navigationTitle("Setting")
    }

    @ViewBuilder
    func LabelItem(option: SettingOptions) -> some View {
        Button {
            settingCoordinator.push(option.screen)
        } label: {
            HStack {
                Label {
                    Text(option.title)
                        .foregroundColor(.black)
                        .fontDesign(.rounded)
                } icon: {
                    Image(systemName: option.icons)
                }
                .padding(.vertical, 4)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .buttonStyle(.borderless)
    }

    @ViewBuilder
    func LogoutSection() -> some View {
        Section(
            header: Text("Logout")
                .font(.headline)
                .foregroundColor(.gray)
        ) {
            Button(
                role: .destructive,
                action: {
                    UserManager.shared.logout()
                },
                label: {
                    Label(
                        "Logout",
                        systemImage: "rectangle.portrait.and.arrow.forward.fill"
                    )
                }
            )
        }
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

    var title: LocalizedStringKey {
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
    case profile
    case deletePost
    case theme

    var id: String { self.rawValue }

    var screen: SettingCoordinator.Screen {
        switch self {
        case .language:
            .language
        case .information:
            .information
        case .createPost:
            .createPost
        case .profile:
            .profile
        case .deletePost:
            .deletePost
        case .theme:
            .theme
        }
    }

    var title: LocalizedStringKey {
        switch self {
        case .language:
            return "Language"
        case .information:
            return "Information"
        case .createPost:
            return "Create Post"
        case .deletePost:
            return "Manage Post"
        case .profile:
            return "User Info"
        case .theme:
            return "Theme"
        }
    }

    var category: SettingCategory {
        switch self {
        case .profile:
            return .account
        case .language, .information, .theme:
            return .general
        case .createPost, .deletePost:
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
        case .deletePost:
            "trash.fill"
        case .profile:
            "person.fill"
        case .theme:
            "circle.lefthalf.filled"
        }
    }
}
