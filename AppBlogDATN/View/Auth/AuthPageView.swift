//
//  AuthPageView.swift
//  swiftDataProject
//
//  Created by TEAMS on 6/11/25.
//

import SwiftUI

struct AuthPageView: View {
    @State var selection: Int = 0
    @StateObject var loginVM = LoginViewModel()
    @State var currentTab: Authtab = .signIn
    var body: some View {
        VStack {
            TopTab(tabs: Authtab.allCases, currentTab: $currentTab)
            
            TabView(selection: $currentTab.animation()) {
                LoginView(loginVM: loginVM)
                    .tag(Authtab.signIn)
                SignUpView()
                    .tag(Authtab.signUp)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
        }
        .loadingViewBuilder(isLoading: loginVM.isLoading)
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

extension Binding {
    func animated(_ animation: Animation = .easeInOut) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                withAnimation(animation) {
                    self.wrappedValue = newValue
                }
            }
        )
    }
}
