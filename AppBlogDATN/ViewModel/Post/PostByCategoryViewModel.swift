//
//  PostByCategoryViewModel.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/8/26.
//

import Foundation

@MainActor
@Observable
class PostByCategoryViewModel {
    
    private(set) var postIds: [String] = []
    var hasNext: Bool = true
    var isLoading: Bool = false
    var errorMessage: String?
    var isError: Bool = false
    
    private var page = 1
    private let limit: Int = 1
    
    private let category: Category
    private let fetchPostCategory: FetchPostByCategoryUseCase
    private let markPostBookmarkUsecase: MarkPostAsBookmarkUsecase
    private let postTranslateService: PostTranslateService

    let postStore: PostStore

    var posts: [PostDetailModel] {
        postStore.posts(ids: postIds)
    }

    init(
        postStore: PostStore,
        category: Category,
        markPostBookmarkUsecase: MarkPostAsBookmarkUsecase,
        fetchPostCategory: FetchPostByCategoryUseCase,
        postTranslateService: PostTranslateService
    ) {
        self.fetchPostCategory = fetchPostCategory
        self.category = category
        self.postStore = postStore
        self.markPostBookmarkUsecase = markPostBookmarkUsecase
        self.postTranslateService = postTranslateService
    }
  
    // MARK: - Fetch
    func getPostsCategory(isRefresh: Bool = false) async {
          guard !isLoading, hasNext else { return }

          if isRefresh {
              page = 1
              hasNext = true
              postIds.removeAll()
          }

          isLoading = true
          isError = false

          do {
              let result = try await fetchPostCategory.execute(
                  category: category,
                  page: page,
                  limit: limit
              )
              postStore.upsert(result.posts)
              postIds.append(contentsOf: result.posts.map(\.id))

              hasNext = result.hasNext
              page += 1
          } catch {
              isError = true
              errorMessage = error.localizedDescription
          }

          isLoading = false
      }

      // MARK: - Bookmark
      func toggleBookmark(postId: String) async -> Bool{
          postStore.update(postId: postId) {
              $0.isBookmarked.toggle()
          }

          do {
              let data = try await markPostBookmarkUsecase.execute(id: postId)
              return data
          } catch {
              postStore.update(postId: postId) {
                  $0.isBookmarked.toggle()
              }
              return false
          }
      }
}

