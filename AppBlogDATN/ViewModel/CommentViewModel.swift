//
//  CommentViewModel.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 31/5/25.
//

import Foundation
import Observation

@MainActor
class CommentViewModel: ObservableObject {
    @Published var comments : [CommentResponse] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showAlert = false
    private var postId: String?
    
    func getComments(postId: String) async {
        isLoading = true
        self.postId = postId
        defer { isLoading = false }
        
        do {
            let data = try await APIServices.shared.sendRequest(
                from: APIEndpoint.getComments(postId: postId),
                type: [CommentResponse].self,
                method: .GET
            )
            comments = mapComments(data)
            print("this is comment\(comments)")
        } catch {
            print("Error fetching comments: \(error)")
        }
    }
    
    func createComment(newContent: String) async {
        guard let userId = UserManager.shared.currentUser?.id else {
            errorMessage = "Vui lòng đăng nhập để bình luận"
            showAlert = true
            return
        }
        guard let postId = postId else {
            errorMessage = "Không có post để get"
            showAlert = true
            return
        }
        
        guard !newContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Vui lòng nhập nội dung bình luận"
            showAlert = true
            return
        }
        let newComment = CommentResquest(content: newContent, postId: postId, userId: userId)
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let created = try await APIServices.shared.sendRequest(from: "/api/comment/create", type: CommentResponse.self, body: newComment)
            let mapped = mapComments([created]).first!
            print("this is created \(created)")
            print("this is mapped\(mapped)")
            self.comments.insert(mapped, at: 0)
            print("xxx\(self.comments)")
        } catch (let error) {
            errorMessage = error.localizedDescription
            print("this is error\(errorMessage)")
        }
    }
    
    func likeComment(commentId: String) async {
        guard let _ = UserManager.shared.currentUser?.id else {
            errorMessage = "Vui lòng đăng nhập để bình luận"
            showAlert = true
            return
        }
       
        do {
            let data =  try await APIServices.shared.sendRequestString(from: "/api/comment/likeComment/\(commentId)", type: EmptyResponse.self, method: .PUT ,body: nil)
        }
        catch(let error) {
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    func deleteComment(commentId: String) async {
        guard let _ = UserManager.shared.currentUser?.id else {
            errorMessage = "Vui lòng đăng nhập"
            showAlert = true
            return
        }
            
        do {
            let deleted = try await APIServices.shared.sendRequestString(from: "/api/comment/deleteComment/\(commentId)", type: EmptyResponse.self, method: .DELETE, body: nil)
            if let index = comments.firstIndex(where: {$0.id == commentId}) {
                comments.remove(at: index)
            }
            
        } catch(let error) {
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    func mapComments(_ comments: [CommentResponse]) -> [CommentResponse] {
        guard let currentUserId = UserManager.shared.currentUser?.id else {
            return comments
        }
        return comments.map { comment in
            var updated = comment
            updated.isLikedByCurrentUser = comment.likes.contains(currentUserId)
            return updated
        }
    }
    
    func translateComment() {
        
    }
}
