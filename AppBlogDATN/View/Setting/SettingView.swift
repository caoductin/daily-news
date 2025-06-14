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
    var body: some View {
        VStack {
            Button {
                UserManager.shared.logout()
            } label: {
                Text("Logout")
            }

            List {
                Section(content: {
                    ForEach(SettingOptions.allCases) { value in
                        NavigationLink(destination: value.destination) {
                            Label(value.infoSettingOption.name, systemImage: value.infoSettingOption.icon)
                        }
                    }
                }, header: {
                    Text("Settings")
                        .font(.headline)
                        .foregroundColor(.gray)
                })
            }.listStyle(.grouped)
            
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
    case savePost
    case userInfo
    
    var id: String { self.rawValue}
    
    var title: String {
        switch self {
        case .language:
            "language"
        case .information:
            "information"
        case .savePost:
            "savePost"
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
        case .savePost:
            ("Save Post", "square.and.arrow.down.fill")
        case .userInfo:
            ("User Infomation", "person.fill")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .language:
            HomeTabbarView()
        case .information:
            HomeTabbarView()
        case .savePost:
            HomeTabbarView()
        case .userInfo:
            HomeTabbarView()
        }
    }
}
