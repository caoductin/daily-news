//
//  PostRelatedView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 7/6/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostRelatedView: View {
    var postRelated: PostDetailModel
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 12) {
//            RemoteImageView(imageURl: postRelated.image, width: UIScreen.main.bounds.width / 2 - 12 );
            AnimatedImage(
                url: postRelated.image,
                placeholderImage: UIImage(named: "defaultPost")
            )
            .resizable()
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .frame(width: UIScreen.main.bounds.width / 2 - 12)
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

            VStack(alignment: .leading) {
                Text(postRelated.title)
                    .lineLimit(3)
              //  Text("\(postRelated.updatedAt.timeAgoFromISO8601())")
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

//#Preview {
//    PostRelatedView()
//}
