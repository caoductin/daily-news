struct CategoryModule {

    private static var cachedViewModels: [Category: PostByCategoryViewModel] = [:]

    @MainActor
    static func makeView(_ category: Category, _ postStore: PostStore) -> PostCategoryView {
        if cachedViewModels[category] == nil {
            let repository = PostRepositoryImpl()
            
            let fetchByCategory = FetchPostByCategoryUseCase(
                repository: repository
            )
            let markPostBookmarkUsecase = MarkPostAsBookmarkUsecase(
                repository: repository
            )
            
            let viewModel = PostByCategoryViewModel(
                postStore: postStore,
                category: category,
                markPostBookmarkUsecase: markPostBookmarkUsecase,
                fetchPostCategory: fetchByCategory
            )
            
            cachedViewModels[category] = viewModel
        }
        return PostCategoryView(postCategoryVM: cachedViewModels[category]!)
    }
}
