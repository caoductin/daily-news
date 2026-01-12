//
//  PostHomeModule.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/11/26.
//

struct PostHomeModule {

    private static var cachedViewModel: HomePostViewModel?

    @MainActor
    static func makeView(postStore: PostStore) -> PostHomeView {
        if cachedViewModel == nil {
            let repository = PostRepositoryImpl()
            
            let fetchPostsUseCase = FetchPostByCategoryUseCase(
                repository: repository
            )
            
            let markPostUseCase = MarkPostAsBookmarkUsecase(
                repository: repository
            )
            
            cachedViewModel = HomePostViewModel(
                postStore: postStore,
                fetchPosts: fetchPostsUseCase,
                markPostBookmarkUsecase: markPostUseCase
            )
        }

        return PostHomeView(viewModel: cachedViewModel!)
    }
}
