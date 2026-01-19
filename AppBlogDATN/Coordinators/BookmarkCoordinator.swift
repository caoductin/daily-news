//
//  BookmarkCoordinator.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/12/26.
//

import SwiftUI

@Observable
class BookmarkCoordinator: Coordinator {
    typealias ScreenType = Screen

    var path = NavigationPath()

    enum Screen: Hashable {
        case postDetail(PostDetailModel, Namespace.ID?)
    }
}
