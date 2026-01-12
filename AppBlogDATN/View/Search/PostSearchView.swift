//
//  PostSearchView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 24/6/25.
//

import SwiftUI

struct PostSearchView: View {
    @State var postViewModel = PostSearchViewModel()
    @Environment(SearchCoordinator.self) private var searchCoordinate

    var body: some View {
        VStack {
            Button {
                searchCoordinate.push(.test)
            } label: {
                Text("Navigation Test")
            }

            TextField("Find the posts...", text: $postViewModel.searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack {
                    ForEach(postViewModel.posts) { post in
                        NavigationLink(value: post) {
                            ArticleCardView(post: post.toDomain())
                                .overlay(Divider(), alignment: .bottom)
                        }
                        .task {
                            await postViewModel.fetchMoreIfNeeded(currentPost: post)
                        }
                    }
                    
                    if postViewModel.isLoading {
                        ProgressView().padding()
                    }
                }
            }
        }
        .navigationDestination(for: PostDetailModel.self) { post in
            PostDetailView(post: post)
        }
        .task {
            if postViewModel.posts.isEmpty {
                await postViewModel.fetchPosts()
            }
        }
    }
}

#Preview {
    PostSearchView()
}


@Observable
@MainActor
class PostSearchViewModel: ObservableObject {
    var posts: [PostDetailResponse] = []
    var searchText: String = "" {
        didSet { resetAndSearch() }
    }
    var isLoading = false
    var hasMore = true
    
    private var currentPage = 1
    private let limit = 10
    private var debounceTask: Task<Void, Never>?
    
    func resetAndSearch() {
        debounceTask?.cancel()
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed != searchText { searchText = trimmed } // clean up nếu cần
            
            currentPage = 1
            hasMore = true
            posts = []
            await fetchPosts()
        }
    }
    
    func fetchMoreIfNeeded(currentPost: PostDetailResponse) async {
        guard !isLoading && hasMore, currentPost.id == posts.last?.id else { return }
        currentPage += 1
        await fetchPosts()
    }
    
    func fetchPosts() async {
        guard hasMore else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let trimmedQuery = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let encodedQuery = trimmedQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            
            let urlString = "http://localhost:3000/api/post/search?query=\(encodedQuery)&page=\(currentPage)&limit=\(limit)"
            guard let url = URL(string: urlString) else { return }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let response = try JSONDecoder().decode(PaginatedPostResponse.self, from: data)
            posts += response.posts
            hasMore = currentPage < response.totalPages
            
        } catch {
            print("❌ Lỗi fetch posts:", error.localizedDescription)
        }
    }
    
}

struct PaginatedPostResponse: Codable {
    let posts: [PostDetailResponse]
    let total: Int
    let page: Int
    let totalPages: Int
}
