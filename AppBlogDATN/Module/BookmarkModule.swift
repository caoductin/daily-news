//
//  BookmarkModule.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/11/26.
//

import Foundation
import SwiftUI

struct BookmarkModule {

    @MainActor
    static func makeView(postStore: PostStore) -> BookmarkView {
        let respository = PostRepositoryImpl()
        
        let fetchBookmarkUseCase = FetchPostBookmarksUsecase(repository: respository)
        let markBookmarkUseCase = MarkPostAsBookmarkUsecase(repository: respository)

        let cachedViewModel = BookmarkViewModel(
            postStore: postStore,
            fetchPostBookmarks: fetchBookmarkUseCase,
            markPostBookmarkUsecase: markBookmarkUseCase
        )
        
        return BookmarkView(viewModel: cachedViewModel)
    }
}
