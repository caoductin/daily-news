//
//  HomeCoordinator.swift
//  AppBlogDATN
//
//  Created by TEAMS on 12/29/25.
//
import SwiftUI


@Observable
class HomeCoordinator: Coordinator {
    typealias ScreenType = Screen

    var path = NavigationPath()

    enum Screen: Hashable {
        case postDetail(PostDetailModel, Namespace.ID?)
    }
}

@Observable
class SearchCoordinator: Coordinator {
    typealias ScreenType = Screen

    var path = NavigationPath()

    enum Screen: Hashable {
        case postDetail(PostDetailModel)
        case test
    }
}
