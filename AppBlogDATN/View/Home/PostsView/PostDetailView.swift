//
//  PostDetailView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 16/5/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostDetailView: View {
    let post: PostDetailResponse
    @StateObject var commentsPost: CommentViewModel = CommentViewModel()
    @StateObject var postRelatedVM: PostRelatedViewModel = PostRelatedViewModel()
    @State private var plainTextContent: Text = Text("")
    @State private var translatedPlainText: String = ""
    @State private var relatedPostToNavigate: PostDetailResponse?
    @State private var commentText = ""

    var displayString: Text {
        if translatedPlainText.isEmpty {
            return post.content.htmlToString()
        } else {
            return plainTextContent
        }
    }
    
    init(post: PostDetailResponse) {
        self.post = post
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(post.title)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    WebImage(url: URL(string: post.image)) { image in
                        image.resizable()
                    } placeholder: {
                        Rectangle().foregroundColor(.gray)
                    }
                    .onSuccess { image, data, cacheType in
                        
                    }
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    
                    displayString
                    CommentsPostView(commentVM: commentsPost)
                    
                    PostRelatedListView(viewModel: postRelatedVM) { selectedPost in
                        relatedPostToNavigate = selectedPost
                    }
                }
            }
            .scrollIndicators(.hidden)
            Divider()
            CommentInputView(commentText: $commentText, onSend: createComment)

        }
        .padding(.horizontal)
        .task {
            loadData()
        }
        .onAppear {
            plainTextContent = post.content.htmlToString()
        }
        .navigationTitle("test")
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        do {
                            let plainText = post.content.htmlToPlainString()
                            let response = try await TranslateViewModel.shared.translate(text: plainText, targetLanguage: "vi")
                            await MainActor.run {
                                translatedPlainText = response.translatedText
                                print(translatedPlainText)
                            }
                        } catch {
                            print("Translation failed:", error)
                        }
                    }
                    
                } label: {
                    Image(systemName: "globe")
                }
            }
        }
    }
}

#Preview {
    let mockPost = PostDetailResponse(
        id: "6824be39121596abb8df7348",
        userId: "user001",
        content: "This is a sample blog post content used for testing",
        category: "Tech",
        title: "Understanding Swift Concurrency",
        slug: "understanding-swift-concurrency",
        image: "https://www.hostinger.com/tutorials/wp-content/uploads/sites/2/2021/09/how-to-write-a-blog-post.png",
        createdAt: "2025-05-20T10:00:00Z",
        updatedAt: "2025-05-21T09:00:00Z"
    )
    
    let mockPostResponse = PostResponse(
        posts: [mockPost, mockPost],
        totalPosts: 2,
        lastMonthPosts: 1
    )
    let postViewModelMock = PostViewModel()
    NavigationStack {
        PostDetailView(post: mockPost)
    }
}

extension PostDetailView {
    private func createComment() {
        Task {
           await commentsPost.createComment(newContent: commentText)
            commentText = ""
        }
    }
    
    private func loadData() {
        Task {
            async let postView:() = commentsPost.getComments(postId: post.id)
            async let postsRelated:() = postRelatedVM.getPostRelated(postId: post.id)
            let (_,_) = try await (postView, postsRelated)
        }
    }
}
