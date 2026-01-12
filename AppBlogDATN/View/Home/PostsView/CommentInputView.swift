//
//  CommentInputView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 14/6/25.
//

import Foundation
import SwiftUI
struct CommentInputView: View {
    @Binding var commentText: String
    var onSend: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            TextField("Write a comment...", text: $commentText, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Button(action: {
                onSend()
            }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
                    .padding(.horizontal, 8)
            }
            .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.vertical, 8)
        .shadow(radius: 1)
    }
}
