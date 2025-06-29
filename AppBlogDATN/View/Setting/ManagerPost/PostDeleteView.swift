//
//  PostDeleteView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 22/6/25.
//

import Foundation
import SwiftUI

struct PostDeleteView: View {
    @StateObject var vm: PostDeleteViewModel = PostDeleteViewModel()
    
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                VStack(alignment: .leading) {
                    PostRelatedView(postRelated: post)
                }
            }
            .onDelete(perform: deletePost)
        }
        .navigationTitle("Xoá post")
        .task {
            await vm.fetchPosts()
        }
        .refreshable {
            await vm.fetchPosts()
        }
    }
    
    func deletePost(at offsets: IndexSet) {
        for index in offsets {
            let post = vm.posts[index]
            Task {
                await vm.deletePost(postId: post.id)
            }
        }
    }
}

#Preview {
    PostDeleteView()
}

@MainActor
class PostDeleteViewModel: ObservableObject {
    @Published var posts: [PostDetailResponse] = []
    @Published var isLoading = false
    @Published var isErrorMessage: String = ""
    private var userManager = UserManager.shared
    
    func fetchPosts() async {
        isLoading = true
        guard let userId = userManager.currentUser?.id else {
            isErrorMessage = "Vui lòng đăng nhập"
            isLoading = false
            return
        }
        do {
            let response = try await APIServices.shared.sendRequest(from: APIEndpoint.getPostsForUserId(userId: userId), type: PostResponse.self)
            posts = response.posts
            print("this is response \(response)")
            isLoading = false
        } catch (let error) {
            isLoading = false
            isErrorMessage = error.localizedDescription
            print("this is error \(error)")
        }
    }
    
    func deletePost(postId: String) async {
        guard let userId = userManager.currentUser?.id else {
            isErrorMessage = "Vui lòng đăng nhập"
            isLoading = false
            return
        }
        do {
            let _ = try await APIServices.shared.sendRequest(from: APIEndpoint.deletePost(postId: postId, userId: userId), type: EmptyResponse.self, method: .DELETE)
            //            self.posts.removeAll { $0.id == postId }
            if let index = posts.firstIndex(where: { $0.id == postId}) {
                posts.remove(at: index)
            }
            isLoading = false
        } catch(let error) {
            isErrorMessage = error.localizedDescription
            isLoading = false
            print("this is error\(error.localizedDescription)")
        }
    }
}
