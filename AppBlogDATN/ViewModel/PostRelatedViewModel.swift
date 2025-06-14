//
//  PostRelatedViewModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 9/6/25.
//

import Foundation

@MainActor
class PostRelatedViewModel: ObservableObject {
    @Published var postsRelated: [PostDetailResponse] = []
    
    func getPostRelated(postId: String) async throws {
        let postRelated = try await APIServices.shared.sendRequest(from: APIEndpoint.getPostsRelated(postId: postId), type: [PostDetailResponse].self, method: .GET)
        print("this is postRelated \(postRelated.map{ $0.title }) - \(postId)")
        postsRelated = postRelated
    }
    
}
