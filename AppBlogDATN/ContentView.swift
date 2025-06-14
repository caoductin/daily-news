//
//  ContentView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loginManager = UserManager.shared
    var body: some View {
        if loginManager.isLogin {
            NavigationStack {
                HomeTabbarView()
            }
        } else {
            NavigationStack {
                HomeTabbarView()
            }
        }
        //        .onAppear {
        //            let _ = TranslatorManager.shared
        //        }
    }
}

#Preview {
    ContentView()
}

