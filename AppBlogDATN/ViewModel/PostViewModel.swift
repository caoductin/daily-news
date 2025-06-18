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
    
    var selectedCategory: CategoryTab = .home {
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
        isLoading = false
    }
    
    func getPost() async {
        isLoading = true
        do {
            let response = try await APIServices.shared.sendRequest(from: APIEndpoint.getPosts, type: PostResponse.self, method: .GET)
            self.allPosts = response.posts
            self.allPosts = response.posts
        } catch(let error) {
            print("lỗi tải bài\(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func filterPosts() {
        if selectedCategory == .home {
            filteredPosts = allPosts
        } else {
            filteredPosts = allPosts.filter {
                $0.category.lowercased() == selectedCategory.rawValue.lowercased()
            }
        }
    }
    
    func didSelectTab(_ tab: CategoryTab) {
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
}


