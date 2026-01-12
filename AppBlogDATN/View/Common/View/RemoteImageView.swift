//
//  RemoteImageView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 7/6/25.
//
import SDWebImageSwiftUI
import SwiftUI

struct RemoteImageView: View {
    var imageURl: String = ""
    var cornerRadius: CGFloat = 10
    var aspectRatio: CGFloat = 16/9
    var width: CGFloat = UIScreen.main.bounds.width - 32
    var height: CGFloat {
        return width / aspectRatio
    }
    
    var body: some View {
        if let url = URL(string: imageURl) {
            WebImage(url: url)
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipped()
                .cornerRadius(cornerRadius)
                .shadow(radius: 2)
        } else {
            Color.gray
                .frame(width: width, height: height)
                .overlay(Text("Invalid URL").foregroundColor(.white))
                .cornerRadius(cornerRadius)
        }
    }
}

#Preview {
    RemoteImageView()
}
