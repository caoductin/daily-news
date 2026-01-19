//
//  SearchViewModel.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/19/26.
//
import SwiftUI

@MainActor
final class SearchViewModel: ObservableObject {

    @Published var query: String = ""
    @Published var posts: [PostDetailModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let searchUseCase: SearchPostUseCase

    init(searchUseCase: SearchPostUseCase) {
        self.searchUseCase = searchUseCase
    }

    func search() async {
        isLoading = true
        errorMessage = nil

        do {
            posts = try await searchUseCase.excute(query: query)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
