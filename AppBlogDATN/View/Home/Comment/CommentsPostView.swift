//
//  CommentsPostView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 1/6/25.
//

import SwiftUI

struct CommentsPostView: View {
    @ObservedObject var commentVM: CommentViewModel
    @State private var showDeleteConfirm = false
    @State private var commentToDelete: CommentResponse?
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Divider() // 👉 Vạch trên

                VStack(spacing: 16) {
                    if commentVM.isLoading {
                        ProgressView("Loading comments...")
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if commentVM.comments.isEmpty {
                        Text("Chưa có bình luận nào")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        HStack {
                            Text("Comment")
                            Spacer()
                            Text("See all")
                        }
                        .font(.headline)
                        .padding(.bottom, 4)

                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach($commentVM.comments, id: \.id) { comment in
                                PostCommentView(commentPost: comment, onLikeTapped: like) { comment in
                                    commentToDelete = comment
                                    showDeleteConfirm = true
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 12)

                Divider()
            }
        }
        .animation(.default, value: commentVM.comments.count)
        .confirmDeleteAlert(
            isPresented: $showDeleteConfirm,
            item: $commentToDelete
        ) { comment in
            Task {
                await commentVM.deleteComment(commentId: comment.id)
            }
        }.alert(commentVM.errorMessage, isPresented: $commentVM.showAlert) {
            Button("OK", role: .cancel) {
                
            }
        }
    }

}

private extension CommentsPostView {
    func like(_ comment: CommentResponse) {
        Task {
            await commentVM.likeComment(commentId: comment.id)
        }
    }
    
    func deleted(_ commentId: String) {
        Task {
            await commentVM.deleteComment(commentId: commentId)
        }
    }
}
