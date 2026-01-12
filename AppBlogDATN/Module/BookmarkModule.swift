//
//  BookmarkModule.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/11/26.
//

import Foundation

struct BookmarkModule {
    @MainActor
    static func makeView(postStore: PostStore) -> BookmarkView {
        let respository = PostRepositoryImpl()
        
        let fetchBookmarkUseCase = FetchPostBookmarksUsecase(repository: respository)
        let markBookmarkUseCase = MarkPostAsBookmarkUsecase(repository: respository)

        let viewModel = BookmarkViewModel(
            postStore: postStore,
            fetchPostBookmarks: fetchBookmarkUseCase,
            markPostBookmarkUsecase: markBookmarkUseCase
        )
        return BookmarkView(viewModel: viewModel)
    }
}
