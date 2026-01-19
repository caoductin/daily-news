//
//  PostRelatedView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 7/6/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostRelatedView: View {
    @Environment(\.locale) private var locale
    var postRelated: PostDetailModel
    var onToggleBookmark: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                AnimatedImage(
                    url: postRelated.image,
                    placeholderImage: UIImage(named: "defaultPost")
                )
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(16/9, contentMode: .fill)
                .frame(height: 160)
                .clipped()
                .overlay(alignment: .topTrailing) {
                    BookmarkButton(isBookmarked: postRelated.isBookmarked) {
                        onToggleBookmark?()
                    }
                    .padding()
                    .fixedSize()
                }
            }
            
            // Content Section
            VStack(alignment: .leading, spacing: 8) {
                // Category Badge
                HStack(spacing: 6) {
                    Circle()
                        .fill(postRelated.category.color.opacity(0.8))
                        .frame(width: 6, height: 6)
                    
                    Text(postRelated.category.title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                }
                .padding(.top, 12)
                
                // Title
                Text(postRelated.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                    
                    Text(postRelated.updatedAt.timeAgoDisplay(locale: locale))
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
    }
}
