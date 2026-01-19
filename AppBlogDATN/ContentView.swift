//
//  ContentView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/4/25.
//

import SwiftUI

#Preview {
    ContentView()
}



struct ContentView: View {
    @AppStorage("appLanguage")
    var appLanguage: String = "vi"
    
    @AppStorage("hasSeenOnboarding")
    private var hasSeenOnboarding = false
    
    @StateObject var loginManager = UserManager.shared
    @State private var reloadID = UUID()
    @State private var appCoordinator = AppCoordinator()
    var body: some View {
        NavigationStack {
            ZStack {
                if let flow = appCoordinator.flow {
                    switch flow {
                    case .auth:
                        AuthPageView()
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .bottom), removal: .slide))
                    case .main:
                        HomeTabbarView()
                            .environment(appCoordinator)
                            .transition(
                                .asymmetric(
                                    insertion: .offset(
                                        CGSize(width: -100, height: 500)),
                                    removal: .slide))
                        
                    case .onBoarding:
                        OnboardingView()
                            .environment(appCoordinator)
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .bottom), removal: .slide))
                    }
                }
            }
            .animation(.smooth(duration: 0.2), value: appCoordinator.flow)
        }
        .onAppear {
            appCoordinator.updateFlow(
                isLoggedIn: loginManager.isLogin,
                hasSeenOnboarding: hasSeenOnboarding
            )
        }
        
        .onChange(of: loginManager.isLogin) { _, _ in
            appCoordinator.updateFlow(
                isLoggedIn: loginManager.isLogin,
                hasSeenOnboarding: hasSeenOnboarding
            )
        }
        
        .onChange(of: hasSeenOnboarding) { _, _ in
            appCoordinator.updateFlow(
                isLoggedIn: loginManager.isLogin,
                hasSeenOnboarding: hasSeenOnboarding
            )
        }
    }
}
