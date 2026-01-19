import SwiftUI

struct SearchModule {

    @MainActor
    static func makeView() -> SearchView {

        // Repository
        let repository = SearchRepositoryImpl()

        // UseCase
        let searchUseCase = SearchPostUseCase(
            repository: repository
        )

        // ViewModel
        let viewModel = SearchViewModel(
            searchUseCase: searchUseCase
        )

        // View
        return SearchView(
            viewModel: viewModel
        )
    }
}
