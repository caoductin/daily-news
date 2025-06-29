//
//  SettingView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 12/6/25.
//

import SwiftUI
import Translation

struct SettingView: View {
    let listSetting = ["home", "remote"]
    let isLogin = UserManager.shared.isLogin
    var body: some View {
        VStack {
            List {
                Section(content: {
                    ForEach(SettingOptions.allCases) { value in
                        NavigationLink(destination: value.destination) {
                            Label(value.infoSettingOption.name, systemImage: value.infoSettingOption.icon)
                                .font(.title2)
                                .padding(.vertical, 8)
                        }
                    }
                }, header: {
                    Text("Settings")
                        .font(.headline)
                        .foregroundColor(.gray)
                })
            }
            .scrollDisabled(true)
            .background(.red)
            .listStyle(.grouped)
            
            Button {
                if isLogin {
                    UserManager.shared.logout()
                } else {
                    //Navigation link to navigaiton 
                }
            } label: {
                Text(isLogin ? "Logout" : "Sign up")
            }
            .padding()
            .buttonStyle(BorderButton(backgroundColor: .blue))
        }
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}

enum SettingOptions: String, CaseIterable, Identifiable {
    case language
    case information
    case createPost
    case userInfo
    case managerPost
    
    var id: String { self.rawValue}
    
    var title: String {
        switch self {
        case .language:
            "language"
        case .information:
            "information"
        case .createPost:
            "createPost"
        case .managerPost:
            "managerPost"
        case .userInfo:
            "userInfo"
        }
    }
    
    var infoSettingOption: (name: String,icon:String) {
        switch self {
        case .language:
            ("Language", "globe")
        case .information:
            ("Information", "info.circle")
        case .createPost:
            ("Create Post", "square.and.arrow.down.fill")
        case .managerPost:
            ("Manager Post","trash")
        case .userInfo:
            ("User Infomation", "person.fill")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .language:
            LanguageSettingView()
        case .information:
            AppInformationView()
        case .createPost:
            PostCreateView()
        case .managerPost:
            PostDeleteView()
        case .userInfo:
            ProfileView()
        }
    }
}
