//
//  AppCoordinator.swift
//  AppBlogDATN
//
//  Created by TEAMS on 12/29/25.
//
import SwiftUI

enum AppFlow {
    case onBoarding
    case auth
    case main
}

@MainActor
@Observable class AppCoordinator {
    
    var flow: AppFlow? = nil
    
    var homeCoordinator = HomeCoordinator()
    var settingCoordinator = SettingCoordinator()
    var searchCoordinator = SearchCoordinator()
    var bookMarkCoordinator = BookmarkCoordinator()
    
    func updateFlow(
        isLoggedIn: Bool,
        hasSeenOnboarding: Bool
    ) {
        if !hasSeenOnboarding {
            flow = .onBoarding
        } else if !isLoggedIn {
            flow = .auth
        } else {
            flow = .main
        }
    }
}

