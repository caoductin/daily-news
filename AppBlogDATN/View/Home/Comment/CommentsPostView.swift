//
//  CommentsPostView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 1/6/25.
//

import SwiftUI

struct CommentsPostView: View {
    @StateObject var commentVM: CommentViewModel
    @Binding var comments: [CommentResponse]
    var body: some View {
        VStack {
            HStack {
                Text("Comment")
                Spacer()
                Text("See all")
            }
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach($commentVM.comments , id: \.id) { comment in
                    PostCommentView(commentPost: comment)
                }
            }
        }.onChange(of: comments) { newValue in
            print("🔄 Comments updated: \(newValue.map { $0.id })")
        }
    }
}

