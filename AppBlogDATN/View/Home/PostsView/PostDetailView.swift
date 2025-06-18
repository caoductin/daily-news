//
//  PostDetailView.swift
//  AppBlogDATN
//
//  Created by cao duc tin  on 16/5/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostDetailView: View {
    @StateObject var commentsPost: CommentViewModel = CommentViewModel()
    @StateObject var postRelatedVM: PostRelatedViewModel = PostRelatedViewModel()
    
    @State var selectedLang: SupportedLang = .vietnamese
    @State private var relatedPostToNavigate: PostDetailResponse?
    @State private var commentText = ""
    @State private var previousLang: SupportedLang = .vietnamese
    @State private var viewModel: PostDetailViewModel
    
    init(post: PostDetailResponse) {
        _viewModel = State(wrappedValue: PostDetailViewModel(post: post))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    SpeechTestView(selectedLanguage: selectedLang.rawValue, textToSpeech: viewModel.displayingPost.content.htmlToPlainString())
                    BodyPostView(viewModel: viewModel)
                        .id(viewModel.displayingPost.id)
                    
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
        .withLoadingOverlay($viewModel.isLoading, message: "Đang tải")
        .onChange(of: viewModel.isLoading, { oldValue, newValue in
            print("gia tri cu vaf moi ne \(oldValue) \(newValue)")
        })
        .onChange(of: viewModel.displayingPost, { oldValue, newValue in
            print("gia tri moiw ne \(oldValue) \(newValue)")
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                TranslateToolbarButton(selectedLang: $selectedLang) { lang in
                    Task {
                        do {
                            await viewModel.translate(to: lang)
                            
                            //                            let translatedComment = try await withThrowingTaskGroup(of: CommentResponse.self) { group in
                            //                                for comment in commentsPost.comments {
                            //                                    group.addTask {
                            //                                        try await comment.translate(lang.rawValue)
                            //                                    }
                            //                                }
                            //
                            //                                var results: [CommentResponse] = []
                            //                                for try await result in group {
                            //                                    results.append(result)
                            //                                }
                            //                                return results
                            //                            }
                        } catch {
                            print("Translate error: \(error)")
                        }
                    }
                }
            }
        }
        .task {
            loadData()
        }
        .navigationTitle("test")
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let mockPost = PostDetailResponse(
        id: "6824be39121596abb8df7348",
        userId: "user001",
        content: "this is a market",
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
            async let postView:() = commentsPost.getComments(postId: viewModel.displayingPost.id)
            async let postsRelated:() = postRelatedVM.getPostRelated(postId: viewModel.displayingPost.id)
            let (_,_) = try await (postView, postsRelated)
        }
    }
}

struct TranslationStatusView: View {
    let isTranslating: Bool
    let translatedText: String
    let originalText: String
    
    var body: some View {
        VStack {
            if isTranslating {
                Text("⏳ Đang dịch...")
                    .foregroundColor(.blue)
            } else if translatedText.isEmpty {
                Text("📄 Nội dung gốc:")
                Text(originalText)
            } else if translatedText == originalText {
                Text("📄 Nội dung dịch giống nội dung gốc")
            } else {
                Text("🌐 Đã dịch:")
                Text(translatedText)
            }
        }
    }
}

struct BodyPostView: View {
    @Bindable var viewModel: PostDetailViewModel
    var body: some View {
        //        ReaderPostView(text: viewModel.displayingPost.content.htmlToPlainString())
        Text(viewModel.displayingPost.title)
            .font(.headline)
            .multilineTextAlignment(.leading)
        WebImage(url: URL(string: viewModel.displayingPost.image)) { image in
            image.resizable()
        } placeholder: {
            Rectangle().foregroundColor(.gray)
        }
        .onSuccess { image, data, cacheType in
            
        }
        .resizable()
        .indicator(.activity)
        .aspectRatio(contentMode: .fit)
        .cornerRadius(8)
        Text(viewModel.displayingPost.content.htmlToPlainString())
    }
}

import Foundation
import Combine

@Observable
@MainActor
class PostDetailViewModel {
    var displayingPost: PostDetailResponse
    var isLoading: Bool = false
    
    init(post: PostDetailResponse) {
        self.displayingPost = post
    }
    
    func translate(to lang: SupportedLang) async {
        isLoading = true
        do {
            let translated = try await displayingPost.translate(lang.rawValue)
            displayingPost = translated
            isLoading = false
        } catch {
            isLoading = false
            print("❌ Translation failed: \(error)")
        }
    }
}


struct LoadingOverlayModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    ProgressView("Loading...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                }
                .transition(.opacity)
                .animation(.easeInOut, value: isLoading)
            }
        }
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool) -> some View {
        self.modifier(LoadingOverlayModifier(isLoading: isLoading))
    }
}
