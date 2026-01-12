//
//  BookmarkViewModel.swift
//  AppBlogDATN
//
//  Created by TEAMS on 1/11/26.
//
import Observation

@Observable
@MainActor
class BookmarkViewModel {

    // MARK: - UseCase
    private let fetchPostBookmarks: FetchPostBookmarksUsecase
    private let markPostBookmarkUsecase: MarkPostAsBookmarkUsecase
    let postStore: PostStore
    
    // MARK: - State
    var hasNext: Bool = true
    var isLoading: Bool = false
    var errorMessage: String?
    var isError: Bool = false

    // MARK: - Paging
    private(set) var postIds: [String] = []
    private var page: Int = 1
    private let limit: Int = 1
    
    var posts: [PostDetailModel] {
        postStore.posts(ids: postIds)
    }

    // MARK: - Init
    init(
        postStore: PostStore,
        fetchPostBookmarks: FetchPostBookmarksUsecase,
        markPostBookmarkUsecase: MarkPostAsBookmarkUsecase
    ) {
        self.postStore = postStore
        self.fetchPostBookmarks = fetchPostBookmarks
        self.markPostBookmarkUsecase = markPostBookmarkUsecase
    }

    // MARK: - Fetch
    func getPostBookmark(isRefresh: Bool = false) async {
          guard !isLoading, hasNext else { return }

          if isRefresh {
              page = 1
              hasNext = true
              postIds.removeAll()
          }

          isLoading = true
          isError = false

          do {
              let result = try await fetchPostBookmarks.execute(
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

      // MARK: - Toggle Bookmark
      func toggleBookmarks(postId: String) async {
          do {
              let bookmarked = try await markPostBookmarkUsecase.execute(id: postId)

              postStore.update(postId: postId) {
                  $0.isBookmarked = bookmarked
              }

              if !bookmarked {
                  postIds.removeAll { $0 == postId }
              }

          } catch {
              isError = true
              errorMessage = error.localizedDescription
          }
      }
}
