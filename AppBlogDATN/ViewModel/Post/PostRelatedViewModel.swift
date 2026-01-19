//
//  PostRelatedViewModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 9/6/25.
//

import Foundation

@MainActor
class PostRelatedViewModel: ObservableObject {
    @Published var postsRelated: [PostDetailModel] = []
    
    private let markPostBookmarkUsecase: MarkPostAsBookmarkUsecase
    
    init(markPostBookmarkUsecase: MarkPostAsBookmarkUsecase) {
        self.markPostBookmarkUsecase = markPostBookmarkUsecase
    }
    
    func getPostRelated(postId: String) async throws {
        do {
            let postRelated = try await APIServices.shared.sendRequest(from: APIEndpoint.getPostsRelated(postId: postId), type: [PostDetailResponse].self, method: .GET)
            print("this is postRelated \(postRelated.map{ $0.title }) - \(postId)")
            postsRelated = postRelated.map{ $0.toDomain()}
        }
        catch {
            print("error get pót related, \(error)")
        }
    }
    
    func toggleBookmark(postId: String) async {
        do {
            let _ = try await markPostBookmarkUsecase.execute(id: postId)
            
            // Update local state
            if let index = postsRelated.firstIndex(where: { $0.id == postId }) {
                postsRelated[index].isBookmarked.toggle()
            }
        } catch {
            print("Error toggling bookmark: \(error)")
        }
    }
}

