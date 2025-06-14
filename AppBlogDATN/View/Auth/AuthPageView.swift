//
//  AuthPageView.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/11/25.
//

import SwiftUI

struct AuthPageView: View {
    @State var currentPage = 0
    @State var isSignIn: Bool = false
    @State var selection: Int
    var body: some View {
        TopTab(tabs: ["sign in", "sign up"], currentTab: $selection)
            
        
        TabView(selection: $selection) {
            LoginView()
                .tag(0)
            Text("Sign up")
                .tag(1)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .never))
    }
}
struct AuthPageViewPreviewWrapper: View {
    @State private var selection = 0
    
    var body: some View {
        AuthPageView(selection: selection)
    }
}
#Preview {
    AuthPageViewPreviewWrapper()
}
