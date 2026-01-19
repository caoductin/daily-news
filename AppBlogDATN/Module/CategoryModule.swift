struct CategoryModule {

    private static var cachedViewModels: [Category: PostByCategoryViewModel] = [:]

    @MainActor
    static func makeView(_ category: Category, _ postStore: PostStore) -> PostCategoryView {
        if cachedViewModels[category] == nil {
            let repository = PostRepositoryImpl()
            
            let translateRepository = TranslateRepositoryImpl()
            
            let translateUseCase = TranslateTextUseCase(
                postRepository: repository,
                translationRepository: translateRepository
            )
            
            let postTranslateService = PostTranslateServiceImpl(
                translateUseCase: translateUseCase
            )
            
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
                fetchPostCategory: fetchByCategory,
                postTranslateService: postTranslateService
            )
            
            cachedViewModels[category] = viewModel
        }
        return PostCategoryView(postCategoryVM: cachedViewModels[category]!)
    }
}
