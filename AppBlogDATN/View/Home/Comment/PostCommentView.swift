//
//  PostCommentView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/5/25.
//

import SwiftUI

struct PostCommentView: View {
    @Binding var commentPost: CommentResponse
    var onlike: () -> Void = {}
    var onReply: () -> Void = {}
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                AvatarView(name: commentPost.userInfo.username)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(commentPost.userInfo.username)
                        .font(.headline)
                    
                    Text(commentPost.content)
                        .font(.body)
                        .lineLimit(20)
                    
                    HStack(spacing: 16) {
                        Button {
                            onlike()
                        }
                        label: {
                            Label("Reply", systemImage: "message")
                        }
                        Button{
                            onReply()
                        }
                        label: {
                            Label("\(commentPost.numberOfLikes)", systemImage: "hand.thumbsup")
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct AvatarView: View {
    let name: String
    var body: some View {
        let firstLetter = name.trimmingCharacters(in: .whitespaces).prefix(2).uppercased()
        
        Text(firstLetter)
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .background(Circle().fill(Color.blue))
    }
}

//#Preview {
//    var comment = CommentResponse(id: "21341", content: "testtesttesttesttest", postId: "123123", userId: "123123", likes: [], numberOfLikes: 12, createdAt: "", updatedAt: "", userInfo: UserResponseComment(id: "123", username: "tuans", profilePicture: ""))
//    PostCommentView(commentPost: comment)
//}
