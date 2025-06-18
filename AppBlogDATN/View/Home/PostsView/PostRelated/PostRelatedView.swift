//
//  PostRelatedView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 7/6/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostRelatedView: View {
    var postRelated: PostDetailResponse = PostDetailResponse.mock(id: "123")
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            RemoteImageView(imageURl: postRelated.image, width: UIScreen.main.bounds.width / 2 - 12 );                VStack(alignment: .leading) {
                Text(postRelated.title)
                    .lineLimit(3)
                Text("\(postRelated.updatedAt.timeAgoFromISO8601())")
            }
        }
    }
}

#Preview {
    PostRelatedView()
}
