//
//  ArticleCardView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 11/5/25.
//

import SDWebImageSwiftUI
import SwiftUI

struct ArticleCardView: View {
    @Environment(\.locale) private var locale
    var post: PostDetailModel
    var onToggleBookmark: (() -> Void)?
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                HStack {
                    AnimatedImage(
                        url: post.image,
                        placeholderImage: UIImage(named: "defaultPost")
                    )
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .overlay {
                        LinearGradient(
                            colors: [Color.black.opacity(0.8), .clear],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    }
                }
                 .overlay(alignment: .topTrailing) {
                    BookmarkButton(isBookmarked: post.isBookmarked) {
                        onToggleBookmark?()
                    }
                    .padding()
                    .fixedSize()
                }
          
                Text(post.title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .lineLimit(3)
                    .padding(8)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
            }
            .frame(height: 250)
            
            FooterCard()
                .padding(.bottom, 4)
                .padding(.horizontal, 8)
        }
        .padding()
    }

    @ViewBuilder
    func FooterCard() -> some View {
        HStack {
            Text(post.category.title)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(post.category.textColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(post.category.backgroundColor)
                )
            Spacer()
            RelativeTime()
        }
    }

    @ViewBuilder
    func RelativeTime() -> some View {
        Text(post.createdAt.timeAgoDisplay(locale: locale))
            .font(.title3)
            .opacity(0.6)
    }
}

struct BookmarkButton: View {

    let isBookmarked: Bool
    let onTap: (() -> Void)?

    @State private var animate = false

    var body: some View {
        Button {
            animate = true
            onTap?()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                animate = false
            }
        } label: {
            ZStack {
                Circle()
                    .stroke(
                        Color.blue.opacity(0.4),
                        lineWidth: 2
                    )
                    .scaleEffect(animate && isBookmarked ? 1.6 : 1)
                    .opacity(animate && isBookmarked ? 0 : 0)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: isBookmarked
                                ? [Color.blue, Color.cyan]
                                : [Color.white, Color(.systemGray6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 46, height: 46)
                    .shadow(
                        color: .black.opacity(0.18),
                        radius: 8, x: 0, y: 4
                    )

                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(
                        isBookmarked ? .white : .gray
                    )
                    .scaleEffect(animate ? 1.25 : 1)
                    .rotationEffect(.degrees(animate ? -10 : 0))
            }
        }
        .animation(
            .spring(response: 0.35, dampingFraction: 0.55), value: animate
        )
        .buttonStyle(.plain)
    }
}

enum Category: String, CaseIterable, Identifiable {
    case home
    case tech
    case sports
    case news
    case science
    case entertainment

    var id: String { self.rawValue }

    init(apiValue: String) {
        self = Category(rawValue: apiValue) ?? .home
    }
}

extension Category: LocalizableTab {
    var title: LocalizedStringKey {
        switch self {
        case .home: return "Home"
        case .entertainment: return "Entertainment"
        case .tech: return "Tech"
        case .news: return "News"
        case .science: return "Science"
        case .sports: return "Sports"
        }
    }

    var color: Color {
        switch self {
        case .home: return .blue
        case .tech: return .yellow
        case .sports: return .red
        case .news: return .green
        case .science: return .purple
        case .entertainment: return .orange
        }
    }

    var textColor: Color {
        color
    }

    var backgroundColor: Color {
        color.opacity(0.15)
    }
}

#Preview {
    ArticleCardView(
        post: PostDetailResponse.mock(id: "123").toDomain()
    )
}
