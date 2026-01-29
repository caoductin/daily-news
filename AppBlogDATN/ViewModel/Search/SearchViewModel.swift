//
//  SearchViewModel.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/19/26.
//
import SwiftUI


@MainActor
@Observable
final class SearchViewModel {
    
    // MARK: - State
    var query = ""
    var postIds: [String] = []
    var isLoading = false
    var errorMessage: String?
    
    // MARK: - Dependencies
    private let postStore: PostStore
    private let searchUseCase: SearchPostUseCase
    private let markPostBookmarkUsecase: MarkPostAsBookmarkUsecase
    
    init(
        postStore: PostStore,
        searchUseCase: SearchPostUseCase,
        markPostBookmarkUsecase: MarkPostAsBookmarkUsecase
    ) {
        self.postStore = postStore
        self.searchUseCase = searchUseCase
        self.markPostBookmarkUsecase = markPostBookmarkUsecase
    }
    
    func search() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let posts = try await searchUseCase.excute(query: query)
            postStore.upsert(posts)
            postIds = posts.map(\.id)
        } catch {
            postIds = []
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func toggleBookmark(postId: String) async -> Bool {
        postStore.update(postId: postId) {
            $0.isBookmarked.toggle()
        }
        
        do {
            let result = try await markPostBookmarkUsecase.execute(id: postId)
            return result
        } catch {
            postStore.update(postId: postId) {
                $0.isBookmarked.toggle()
            }
            return false
        }
    }
}

