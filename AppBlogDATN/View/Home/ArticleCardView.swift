//
//  ArticleCardView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 11/5/25.
//

import SwiftUI
import SDWebImageSwiftUI

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
                
                VStack(alignment: .trailing) {
                    HeartButton(
                        isBookmarked: post.isBookmarked,
                        onTap: onToggleBookmark
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding()
                    
                    Spacer()
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
                .padding(.bottom,4)
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
        Text("Relative time:")
            .fontWeight(.bold)
        Text(post.createdAt.timeAgoDisplay(locale: locale))
            .font(.title3)
            .opacity(0.6)
    }
}

struct HeartButton: View {
    
    let isBookmarked: Bool
    let onTap: (() -> Void)?
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                onTap?()
            }
        } label: {
            Image(systemName: isBookmarked ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(isBookmarked ? .red : .gray)
                .padding(10)
                .background(
                    Circle()
                        .fill(
                            isBookmarked
                            ? Color(uiColor: .systemRed).opacity(0.4)
                            : Color(uiColor: .systemGray4)
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4)
                )
        }
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
        case .tech : return .yellow
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
