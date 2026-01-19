//
//  PostSearchView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 24/6/25.
//

//import SwiftUI
//
//struct PostSearchView: View {
//    @State var postViewModel = PostSearchViewModel()
//
//    var body: some View {
//        VStack {
//            TextField("Find the posts...", text: $postViewModel.searchText)
//                .padding(10)
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//                .padding(.horizontal)
//            
//            ScrollView {
//                LazyVStack {
//                    ForEach(postViewModel.posts) { post in
//                        NavigationLink(value: post) {
//                            ArticleCardView(post: post.toDomain())
//                                .overlay(Divider(), alignment: .bottom)
//                        }
//                        .task {
//                            await postViewModel.fetchMoreIfNeeded(currentPost: post)
//                        }
//                    }
//                    
//                    if postViewModel.isLoading {
//                        ProgressView().padding()
//                    }
//                }
//            }
//        }
//        .navigationDestination(for: PostDetailModel.self) { post in
//            PostDetailView(post: post)
//        }
//        .task {
//            if postViewModel.posts.isEmpty {
//                await postViewModel.fetchPosts()
//            }
//        }
//    }
//}
//
//#Preview {
//    PostSearchView()
//}
import SwiftUI

struct SearchView: View {

    @StateObject var viewModel: SearchViewModel

    var body: some View {
        VStack(spacing: 12) {

            // Search bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")

                TextField("Search posts...", text: $viewModel.query)
                    .textFieldStyle(.plain)
                    .submitLabel(.search)
                    .onSubmit {
                        Task { await viewModel.search() }
                    }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3))
            )
            .padding(.horizontal)

            // Loading
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 20)
            }

            // Error
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            // Result
            List(viewModel.posts) { post in
                SearchPostRow(post: post)
            }
            .listStyle(.plain)
        }
        .navigationTitle("Search")
    }
}

struct SearchPostRow: View {
    let post: PostDetailModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(post.title)
                .font(.headline)

            Text(post.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 6)
    }
}
