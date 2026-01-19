//
//  SettingCoordinator.swift
//  AppBlogDATN
//
//  Created by TEAMS on 12/29/25.
//

import SwiftUI


@Observable class SettingCoordinator: Coordinator {
    typealias ScreenType = Screen
    
    var path = NavigationPath()
    
    enum Screen: Hashable {
        case profile
        case language
        case information
        case createPost
        case deletePost
        case theme
    }
    
}
