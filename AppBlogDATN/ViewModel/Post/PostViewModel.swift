//
//  PostViewModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 15/5/25.
//

import Foundation

@Observable
class PostViewModel {
    var posts: PostResponse?
    var postsPaginated: PostPaginatedResponse?
    var postsRelated: [PostDetailResponse] = []
    var allPosts: [PostDetailResponse] = []
    var filteredPosts: [PostDetailResponse] = []
    var postCategory: PostResponse?
    var isLoading = false
    var currentPage = 1
    var totalPages = 1
    var showAlert = false
    var alertMessage = ""
        

    var searchText: String = "" {
        didSet {
            debounceSearch()
        }
    }
    
    private var debounceTask: Task<Void, Never>?
    
    var selectedCategory: Category = .home {
        didSet {
            filterPosts()
        }
    }
    
    private var hasCalledInitialLoad = false
    
    func initialLoadIfNeeded() {
        guard !hasCalledInitialLoad else { return }
        hasCalledInitialLoad = true
        Task {
            try? await getPaginatedPosts(reset: true)
        }
    }
    
    func loadMoreContentIfNeeded(currentPost: PostDetailResponse) {
        guard !isLoading,
              let lastPost = postsPaginated?.posts.last else {
            return
        }
        
        guard currentPost.id == lastPost.id else {
            return
        }
        
        Task {
            try? await getPaginatedPosts()
        }
    }
    
    func getPaginatedPosts(reset: Bool = false) async throws {
        defer {
            isLoading = false
        }
        guard !isLoading, currentPage <= totalPages else {
            return
        }
        
        isLoading = true
        
        if reset {
            currentPage = 1
            totalPages = 1
            postsPaginated = PostPaginatedResponse(posts: [], currentPage: 1, totalPages: 1, totalPosts: 0)
        }
        
        let response = try await APIServices.shared.sendRequest(
            from: APIEndpoint.getPaginatedPosts(currentPage: currentPage, limit: 5),
            type: PostPaginatedResponse.self,
            method: .GET
        )
        
        if reset || postsPaginated == nil {
            postsPaginated = response
            totalPages = response.totalPages
        } else {
            var updated = postsPaginated!
            updated.posts += response.posts
            updated.totalPosts = response.totalPosts
            updated.totalPages = response.totalPages
            totalPages = response.totalPages
            postsPaginated = updated
        }
        currentPage += 1
    }
    
    func getPost() async {
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            let response = try await APIServices.shared.sendRequest(from: APIEndpoint.getPosts, type: PostResponse.self, method: .GET)
            self.allPosts = response.posts
            self.filteredPosts = response.posts
            self.allPosts = response.posts
        } catch(let error) {
            print("lỗi tải bài\(error.localizedDescription)")
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    func filterPosts() {
//        if selectedCategory == .home {
//            filteredPosts = allPosts
//        } else {
//            filteredPosts = allPosts.filter {
//                $0.category.lowercased() == selectedCategory.rawValue.lowercased()
//            }
//        }
    }

    func fetchPostByCategory(category: Category, page: Int, limit: Int) {
        
    }
    
    func didSelectTab(_ tab: Category) {
        selectedCategory = tab
    }
    
    func deletePost(postID: String) async throws {
        // implement delete logic here
    }
    
    func getPostRelated(postId: String) async throws {
        let postRelated = try await APIServices.shared.sendRequest(from: APIEndpoint.getPostsRelated(postId: postId), type: [PostDetailResponse].self, method: .GET)
        print("this is postRelated \(postRelated.map{ $0.title }) - \(postId)")
        postsRelated = postRelated
    }
    
    //MARK: SEARCH
    
    private func debounceSearch() {
        debounceTask?.cancel()
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 500ms debounce
            await MainActor.run {
                self.searchPosts(query: self.searchText)
            }
        }
    }
    
    func searchPosts(query: String) {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            filteredPosts = allPosts
        } else {
            filteredPosts = allPosts.filter {
                $0.title.localizedCaseInsensitiveContains(query)
            }
        }
    }
}


@Observable
@MainActor
final class HomePostViewModel {
    // MARK: - State
    var postIds: [String] = []
    var isLoading = false
    var hasNext = true
    var isError = false
    var errorMessage: String?

    // MARK: - Pagination
    private var page = 1
    private let limit = 6

    // MARK: - Dependencies
    private let postStore: PostStore
    private let fetchPosts: FetchPostByCategoryUseCase
    private let markPostBookmarkUsecase: MarkPostAsBookmarkUsecase
    private let postTranslateService: PostTranslateService

    init(
        postStore: PostStore,
        fetchPosts: FetchPostByCategoryUseCase,
        markPostBookmarkUsecase: MarkPostAsBookmarkUsecase,
        postTranslateService: PostTranslateService
    ) {
        self.postStore = postStore
        self.fetchPosts = fetchPosts
        self.markPostBookmarkUsecase = markPostBookmarkUsecase
        self.postTranslateService = postTranslateService
    }

    func getPosts(isRefresh: Bool = false) async {
        guard !isLoading, hasNext else { return }

        if isRefresh {
            page = 1
            hasNext = true
            postIds.removeAll()
        }

        isLoading = true
        isError = false

        do {
            let result = try await fetchPosts.execute(
                category: nil,
                page: page,
                limit: limit
            )

            postStore.upsert(result.posts)
            let newIds = result.posts.map(\.id)
            postIds.append(contentsOf: newIds)

            // 🔥 QUAN TRỌNG: auto translate nếu đang bật
            if postStore.isTranslateEnabled {
                await postStore.translateTitlesIfNeeded(
                    postIds: newIds,
                    service: postTranslateService
                )
            }

            hasNext = result.hasNext
            page += 1
        } catch {
            isError = true
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    
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
