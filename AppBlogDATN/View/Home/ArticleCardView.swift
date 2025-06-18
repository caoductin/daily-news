//
//  ArticleCardView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 11/5/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArticleCardView: View {
    var imageURL: String
    let title: String
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let url = URL(string: imageURL) {
                HStack {
                    WebImage(url: url)
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                        .clipped()
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
            } else {
                Color.gray
                    .frame(height: 200)
                    .overlay(Text("URL không hợp lệ").foregroundColor(.white))
                    .cornerRadius(10)
                    .padding(.vertical, 10)
            }
            
            HStack (spacing: 20) {
                Text("1 likes")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                Spacer()
                Image(systemName: "hand.thumbsup")
                    .font(.system(size: 25))
                Image(systemName: "message")
                    .font(.system(size: 25))
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 25))
            }
        }
        .padding()
    }
}

#Preview {
    ArticleCardView(imageURL: "https://www.hostinger.com/tutorials/wp-content/uploads/sites/2/2021/09/how-to-write-a-blog-post.png", title: "the tragedy that changed hallmark start megan parks life")
}
