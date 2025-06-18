//
//  PostCommentView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 21/5/25.
//

import SwiftUI

struct PostCommentView: View {
    @Binding var commentPost: CommentResponse
    @State private var isLiked: Bool = false
    @State private var likeCount: Int = 0
    var onLikeTapped: ((CommentResponse) -> Void)? = nil
    var onDeleteTapped: ((CommentResponse) -> Void)? = nil
    let profileImage = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                AvatarView(name: commentPost.userInfo?.username ?? profileImage)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(commentPost.userInfo?.username ?? getUserName())
                        .font(.headline)
                    
                    Text(commentPost.content)
                        .font(.body)
                        .lineLimit(20)
                    
                    HStack(spacing: 16) {
                        Button {
                            onDeleteTapped?(commentPost)
                        }
                        label: {
                            Label("Xoá", systemImage: "message")
                        }
                        Button {
                            if UserManager.shared.isLogin {
                                isLiked.toggle()
                                likeCount += isLiked ? 1 : -1
                            }
                            onLikeTapped?(commentPost)
                        }
                        label: {
                            Label("\(likeCount)", systemImage: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                .foregroundColor(isLiked ? .blue : .gray)
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onAppear {
                isLiked = commentPost.isLikedByCurrentUser
                likeCount = commentPost.numberOfLikes
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

extension PostCommentView {
    private func getUserName() -> String {
        return UserManager.shared.currentUser?.username ?? "Không xác định"
    }
}
