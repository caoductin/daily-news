import SwiftUI

struct SearchModule {

    @MainActor
    static func makeView(postStore: PostStore) -> SearchView {

        let repository = SearchRepositoryImpl()
        let repositoryPost = PostRepositoryImpl()

        let searchUseCase = SearchPostUseCase(
            repository: repository
        )
        
        let markPostUseCase = MarkPostAsBookmarkUsecase(
            repository: repositoryPost
        )

        let viewModel = SearchViewModel(
            postStore: postStore,
            searchUseCase: searchUseCase,
            markPostBookmarkUsecase: markPostUseCase
        )

        return SearchView(
            viewModel: viewModel
        )
    }
}
