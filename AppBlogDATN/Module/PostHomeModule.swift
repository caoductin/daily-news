//
//  PostHomeModule.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/11/26.
//

import SwiftUI

struct PostHomeModule {

    private static var cachedViewModel: HomePostViewModel?

    @MainActor
    static func makeView(postStore: PostStore, ns: Namespace.ID? = nil) -> PostHomeView {
        if cachedViewModel == nil {
            let repository = PostRepositoryImpl()
            
            let translateRepository = TranslateRepositoryImpl()
            
            let fetchPostsUseCase = FetchPostByCategoryUseCase(
                repository: repository
            )
            
            let markPostUseCase = MarkPostAsBookmarkUsecase(
                repository: repository
            )
            
            let translateUseCase = TranslateTextUseCase(
                postRepository: repository,
                translationRepository: translateRepository
            )
            
            let postTranslateService = PostTranslateServiceImpl(
                translateUseCase: translateUseCase
            )
            
            cachedViewModel = HomePostViewModel(
                postStore: postStore,
                fetchPosts: fetchPostsUseCase,
                markPostBookmarkUsecase: markPostUseCase,
                postTranslateService: postTranslateService
            )
        }

        return PostHomeView(viewModel: cachedViewModel!)
    }
}
